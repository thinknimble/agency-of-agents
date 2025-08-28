#!/usr/bin/env python3
# /// script
# dependencies = [
#     "google-auth==2.34.0",
#     "google-auth-oauthlib==1.2.0",
#     "google-auth-httplib2==0.2.0",
#     "google-api-python-client==2.137.0",
#     "requests==2.32.3",
# ]
# ///
"""
Script to dump the full contents of a Google Doc to a local file.
Uses the same OAuth credentials as the MCP Google Docs integration.

Usage:
    uv run dump_google_doc.py <document_id_or_url> [output_file]
"""

import os
import sys
import json
import pickle
import requests
from pathlib import Path
from urllib.parse import urlparse
from datetime import datetime
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# If modifying these scopes, delete the token file.
# Note: Using same scopes as MCP to ensure compatibility
SCOPES = [
    'https://www.googleapis.com/auth/documents',
    'https://www.googleapis.com/auth/drive'
]

def get_credentials():
    """Get valid user credentials from storage or initiate OAuth flow."""
    creds = None
    
    # Token file paths
    mcp_token_path = Path.home() / '.config' / 'claude-code' / 'mcp-servers' / 'google-docs-mcp' / 'token.json'
    credentials_path = Path(__file__).parent / 'mcps' / 'google-docs' / 'credentials.json'
    
    # Load existing token from MCP location
    if mcp_token_path.exists():
        try:
            with open(mcp_token_path, 'r') as token:
                token_data = json.load(token)
                creds = Credentials.from_authorized_user_info(token_data, SCOPES)
        except Exception as e:
            print(f"Warning: Could not load MCP token: {e}")
    
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not credentials_path.exists():
                print(f"Error: Credentials file not found at {credentials_path}")
                sys.exit(1)
                
            flow = InstalledAppFlow.from_client_secrets_file(
                str(credentials_path), SCOPES)
            creds = flow.run_local_server(port=0)
            
        # Save the credentials in MCP format for next run
        token_data = {
            'type': 'authorized_user',
            'client_id': creds.client_id,
            'client_secret': creds.client_secret,
            'refresh_token': creds.refresh_token
        }
        mcp_token_path.parent.mkdir(parents=True, exist_ok=True)
        with open(mcp_token_path, 'w') as token:
            json.dump(token_data, token)
    
    return creds

def dump_document(document_id, output_file=None):
    """Dump the full contents of a Google Doc to a file, including images."""
    try:
        # Get credentials and build service
        creds = get_credentials()
        service = build('docs', 'v1', credentials=creds)
        
        # Retrieve the document
        document = service.documents().get(documentId=document_id).execute()
        
        # Extract document title for default filename
        title = document.get('title', 'untitled')
        
        # Determine output filename
        if output_file is None:
            # Sanitize title for filename
            safe_title = "".join(c for c in title if c.isalnum() or c in (' ', '-', '_')).rstrip()
            output_file = f"{safe_title}.md"
        
        # Prepare images directory path (but don't create it yet)
        output_path = Path(output_file)
        images_dir = output_path.parent / f"{output_path.stem}_images"
        
        # Track images and their counter
        image_counter = 0
        inline_objects = document.get('inlineObjects', {})
        
        # Extract all content
        content = []
        
        def download_image(image_url, image_name):
            """Download an image from a URL and save it locally."""
            try:
                # Create images directory on first image download
                if not images_dir.exists():
                    images_dir.mkdir(exist_ok=True)
                
                # Add authorization header for Google Drive images
                headers = {'Authorization': f'Bearer {creds.token}'}
                response = requests.get(image_url, headers=headers, timeout=30)
                response.raise_for_status()
                
                # Save the image
                image_path = images_dir / image_name
                with open(image_path, 'wb') as f:
                    f.write(response.content)
                
                return str(image_path.relative_to(output_path.parent))
            except Exception as e:
                print(f"   ⚠️  Warning: Could not download image: {e}")
                return None
        
        def extract_content_from_element(element):
            """Recursively extract text and images from a document element."""
            nonlocal image_counter
            content_parts = []
            
            if 'paragraph' in element:
                for elem in element['paragraph']['elements']:
                    if 'textRun' in elem:
                        content_parts.append(elem['textRun']['content'])
                    elif 'inlineObjectElement' in elem:
                        # Handle inline images
                        inline_obj_id = elem['inlineObjectElement']['inlineObjectId']
                        if inline_obj_id in inline_objects:
                            inline_obj = inline_objects[inline_obj_id]
                            image_props = inline_obj.get('inlineObjectProperties', {})
                            embedded_obj = image_props.get('embeddedObject', {})
                            
                            # Get image URL
                            image_url = embedded_obj.get('imageProperties', {}).get('contentUri')
                            if image_url:
                                image_counter += 1
                                # Determine image extension from URL or default to .png
                                parsed_url = urlparse(image_url)
                                ext = '.png'
                                if '.' in parsed_url.path:
                                    ext = Path(parsed_url.path).suffix or '.png'
                                
                                image_name = f"image_{image_counter}{ext}"
                                
                                # Download the image
                                print(f"   📥 Downloading image {image_counter}...")
                                relative_path = download_image(image_url, image_name)
                                
                                if relative_path:
                                    # Add markdown image reference
                                    content_parts.append(f"\n![Image {image_counter}]({relative_path})\n")
                                else:
                                    content_parts.append(f"\n[Image {image_counter} - Failed to download]\n")
            
            elif 'table' in element:
                # Handle tables
                table_text = "\n"
                for row in element['table']['tableRows']:
                    row_text = []
                    for cell in row['tableCells']:
                        cell_text = ''
                        for content_elem in cell['content']:
                            cell_text += extract_content_from_element(content_elem)
                        row_text.append(cell_text.strip())
                    table_text += ' | '.join(row_text) + '\n'
                content_parts.append(table_text)
            
            elif 'sectionBreak' in element:
                content_parts.append('\n---\n')
            
            return ''.join(content_parts)
        
        # Process document body
        body = document.get('body', {})
        for element in body.get('content', []):
            content.append(extract_content_from_element(element))
        
        # Join all content
        full_content = ''.join(content)
        
        # Write to file with metadata header
        with open(output_file, 'w', encoding='utf-8') as f:
            # Add metadata header
            f.write("<!--\n")
            f.write(f"Google Doc ID: {document_id}\n")
            f.write(f"Source URL: https://docs.google.com/document/d/{document_id}/edit\n")
            f.write(f"Downloaded: {datetime.now().isoformat()}\n")
            f.write("-->\n\n")
            
            # Add document title and content
            f.write(f"# {title}\n\n")
            f.write(full_content)
        
        print(f"✅ Successfully dumped document to: {output_file}")
        print(f"   Document title: {title}")
        print(f"   Total characters: {len(full_content)}")
        if image_counter > 0:
            print(f"   Images downloaded: {image_counter}")
            print(f"   Images saved to: {images_dir}")
        else:
            print(f"   No images found in document")
        
        return output_file
        
    except HttpError as error:
        print(f'❌ An error occurred: {error}')
        return None

def main():
    """Main function to handle command line arguments."""
    if len(sys.argv) < 2:
        print("Usage: uv run dump_google_doc.py <document_id_or_url> [output_file]")
        print("\nExamples:")
        print("  uv run dump_google_doc.py 1vlK2Rvwk9VbvypXjBSp2gfLdKLlGRLYAf8iyUP8p7lA")
        print("  uv run dump_google_doc.py https://docs.google.com/document/d/1vlK2Rvwk9VbvypXjBSp2gfLdKLlGRLYAf8iyUP8p7lA/edit output.md")
        print("\nNote: This script uses uv to automatically manage dependencies.")
        sys.exit(1)
    
    # Extract document ID from URL or use as-is
    doc_input = sys.argv[1]
    if 'docs.google.com' in doc_input:
        # Extract ID from URL
        parts = doc_input.split('/d/')
        if len(parts) > 1:
            document_id = parts[1].split('/')[0]
        else:
            print("❌ Error: Could not extract document ID from URL")
            sys.exit(1)
    else:
        document_id = doc_input
    
    # Get output file if specified
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    # Dump the document
    dump_document(document_id, output_file)

if __name__ == '__main__':
    main()