#!/bin/bash

# Google Docs MCP Server Setup Script
# This script automates the installation and configuration of the a-bonus/google-docs-mcp server
# which provides comprehensive Google Docs and Drive functionality

set -e  # Exit on error

echo "========================================="
echo "Google Docs MCP Server Setup"
echo "========================================="
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js v16 or higher."
    echo "   Visit: https://nodejs.org/"
    exit 1
else
    NODE_VERSION=$(node -v)
    echo "✅ Node.js installed: $NODE_VERSION"
fi

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm."
    exit 1
else
    NPM_VERSION=$(npm -v)
    echo "✅ npm installed: $NPM_VERSION"
fi

# Check Claude Code
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code is not installed. Please install Claude Code first."
    echo "   Visit: https://docs.anthropic.com/en/docs/claude-code"
    exit 1
else
    echo "✅ Claude Code is installed"
fi

echo ""
echo "Installing Google Docs MCP Server..."

# Create directory for MCP servers
MCP_DIR="$HOME/.config/claude-code/mcp-servers"
mkdir -p "$MCP_DIR"

# Clone the repository
if [ -d "$MCP_DIR/google-docs-mcp" ]; then
    echo "Repository already exists. Updating..."
    cd "$MCP_DIR/google-docs-mcp"
    git pull
else
    echo "Cloning repository..."
    cd "$MCP_DIR"
    git clone https://github.com/a-bonus/google-docs-mcp.git
    cd google-docs-mcp
fi

# Install dependencies
echo ""
echo "Installing dependencies..."
npm install

# Build the project
echo ""
echo "Building the project..."
npm run build

echo ""
echo "========================================="
echo "Google Cloud Setup Required"
echo "========================================="
echo ""
echo "Before continuing, you need to set up Google Cloud authentication:"
echo ""
echo "1. Go to: https://console.cloud.google.com/"
echo "2. Create a new project (or use existing)"
echo "3. Enable these APIs:"
echo "   - Google Drive API"
echo "   - Google Docs API"
echo ""
echo "4. Configure OAuth consent screen:"
echo "   - Choose 'Internal' for organization use or 'External' for personal"
echo "   - Add your email as a test user"
echo "   - Add scopes:"
echo "     • https://www.googleapis.com/auth/documents"
echo "     • https://www.googleapis.com/auth/drive"
echo ""
echo "5. Create OAuth 2.0 credentials:"
echo "   - Type: Desktop app"
echo "   - Download the JSON file"
echo ""

# Check if we can reuse existing OAuth credentials
EXISTING_OAUTH=""
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f "$SCRIPT_DIR/credentials.json" ]; then
    echo "✅ Found project OAuth credentials"
    EXISTING_OAUTH="$SCRIPT_DIR/credentials.json"
elif [ -f "$HOME/.config/mcp-gdrive/gcp-oauth.keys.json" ]; then
    echo "✅ Found existing OAuth credentials from previous MCP installation"
    read -p "Would you like to reuse these credentials? (y/n): " REUSE_CREDS
    if [ "$REUSE_CREDS" = "y" ] || [ "$REUSE_CREDS" = "Y" ]; then
        EXISTING_OAUTH="$HOME/.config/mcp-gdrive/gcp-oauth.keys.json"
    fi
elif [ -f "$HOME/google-oauth-backup.json" ]; then
    echo "✅ Found OAuth credentials backup"
    read -p "Would you like to use the backup credentials? (y/n): " USE_BACKUP
    if [ "$USE_BACKUP" = "y" ] || [ "$USE_BACKUP" = "Y" ]; then
        EXISTING_OAUTH="$HOME/google-oauth-backup.json"
    fi
fi

# Handle OAuth credentials
if [ -f "$MCP_DIR/google-docs-mcp/credentials.json" ]; then
    echo "✅ OAuth credentials already exist in project"
    echo "   Skipping OAuth file setup..."
elif [ -n "$EXISTING_OAUTH" ]; then
    # Copy existing OAuth file
    cp "$EXISTING_OAUTH" "$MCP_DIR/google-docs-mcp/credentials.json"
    echo "✅ Copied existing OAuth credentials"
else
    read -p "Press Enter when you have downloaded the OAuth credentials JSON file..."
    # Get the OAuth file
    echo ""
    echo "Please provide the path to your downloaded OAuth credentials JSON file:"
    read -p "Path: " OAUTH_PATH

    if [ ! -f "$OAUTH_PATH" ]; then
        echo "❌ File not found: $OAUTH_PATH"
        exit 1
    fi

    # Copy OAuth file to project directory
    cp "$OAUTH_PATH" "$MCP_DIR/google-docs-mcp/credentials.json"
    echo "✅ OAuth credentials saved to project directory"
fi

# Important note about scopes
echo ""
echo "⚠️  IMPORTANT: If reusing credentials from the old MCP, you may need to:"
echo "   1. Update the OAuth scopes in Google Cloud Console to include:"
echo "      - https://www.googleapis.com/auth/documents"
echo "      - https://www.googleapis.com/auth/drive"
echo "   2. Re-authenticate to get new permissions"
echo ""
read -p "Press Enter to continue..."

# Add to Claude Code
echo ""
echo "========================================="
echo "Adding to Claude Code"
echo "========================================="
echo ""

echo "Adding Google Docs MCP server to Claude Code..."
cd "$MCP_DIR/google-docs-mcp"
FULL_PATH=$(pwd)
claude mcp add google-docs stdio "node" "$FULL_PATH/dist/server.js"

# Verify the MCP server was added
echo ""
echo "Verifying MCP server configuration..."
# Wait a moment for the configuration to take effect
sleep 2

# Check if the server was added (it might show as failing initially)
if claude mcp list 2>/dev/null | grep -q "google-docs"; then
    echo "✅ Google Docs MCP server successfully added to Claude Code"
    
    # Check connection status
    if claude mcp list 2>/dev/null | grep "google-docs" | grep -q "✗ Failed to connect"; then
        echo ""
        echo "⚠️  Note: The server is added but showing 'Failed to connect'."
        echo "   This is normal before the first authentication."
        echo "   The server will start working after you:"
        echo "   1. Restart Claude Code with: claude restart"
        echo "   2. Authenticate with Google (see instructions below)"
    fi
else
    echo "⚠️  Failed to add MCP server to Claude Code"
    echo "   Please try manually adding with:"
    echo "   claude mcp add google-docs stdio node $FULL_PATH/dist/server.js"
fi

echo ""
echo "========================================="
echo "Authentication"
echo "========================================="
echo ""

# Offer to run authentication now
echo "Would you like to authenticate with Google now?"
read -p "This will open a browser window for authentication (y/n): " AUTH_NOW

if [ "$AUTH_NOW" = "y" ] || [ "$AUTH_NOW" = "Y" ]; then
    echo ""
    echo "Running authentication flow..."
    echo ""
    
    # Run the server once to trigger authentication
    cd "$MCP_DIR/google-docs-mcp"
    
    # Create a temporary script to handle the authentication
    cat > auth_helper.js << 'EOF'
const { exec } = require('child_process');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

// Start the server
const serverProcess = exec('node dist/server.js', (error, stdout, stderr) => {
  if (error) {
    console.error(`Error: ${error.message}`);
    return;
  }
});

let authUrlShown = false;

serverProcess.stdout.on('data', (data) => {
  const output = data.toString();
  
  // Look for the auth URL
  if (output.includes('Authorize this app by visiting this url:')) {
    const urlMatch = output.match(/https:\/\/accounts\.google\.com[^\s]+/);
    if (urlMatch && !authUrlShown) {
      authUrlShown = true;
      console.log('\n📋 Please follow these steps:');
      console.log('1. Open this URL in your browser:');
      console.log(`   ${urlMatch[0]}`);
      console.log('\n2. Grant permissions to access Google Docs and Drive');
      console.log('3. You will be redirected to "This site can\'t be reached"');
      console.log('4. Copy the code from the URL (between code= and &scope)');
      console.log('\nExample: http://localhost/?code=YOUR_CODE_HERE&scope=...');
      console.log('         Copy this part: ^^^^^^^^^^^^^^^^\n');
    }
  }
  
  // Look for the prompt
  if (output.includes('Enter the code from that page here:')) {
    rl.question('📝 Paste the authorization code here: ', (code) => {
      serverProcess.stdin.write(code + '\n');
    });
  }
  
  // Look for success
  if (output.includes('Authentication successful!')) {
    console.log('\n✅ Authentication successful!');
    setTimeout(() => {
      serverProcess.kill();
      rl.close();
      process.exit(0);
    }, 1000);
  }
});

serverProcess.stderr.on('data', (data) => {
  if (!data.toString().includes('FastMCP could not infer client capabilities')) {
    console.error(`Error: ${data}`);
  }
});
EOF

    # Run the authentication helper
    node auth_helper.js
    
    # Clean up
    rm -f auth_helper.js
    
    echo ""
    echo "✅ Authentication completed!"
else
    echo ""
    echo "You can authenticate later. The first time you use the MCP server:"
    echo "1. A URL will be displayed in the Claude Code logs"
    echo "2. Open the URL in your browser"
    echo "3. Sign in with your Google account"
    echo "4. Copy the authorization code"
    echo "5. Paste it when prompted"
fi

echo ""
echo "To check the server status:"
echo "  claude mcp list"
echo ""

echo ""
echo "========================================="
echo "Setup Complete! 🎉"
echo "========================================="
echo ""
echo "Google Docs MCP server has been installed and configured."
echo ""
echo "This comprehensive server provides:"
echo "  - Complete Google Drive file management"
echo "  - Document creation, reading, editing, and formatting"
echo "  - Folder operations (create, move, copy, rename, delete)"
echo "  - Advanced search capabilities"
echo "  - And much more!"
echo ""
echo "OAuth credentials are stored in:"
echo "  $MCP_DIR/google-docs-mcp/credentials.json"
echo ""
echo "To test the connection:"
echo "1. Restart Claude Code: claude restart"
echo "2. Try: 'List my recent Google Docs'"
echo ""
echo "For troubleshooting:"
echo "  - Check server status: claude mcp list"
echo "  - Try restarting: claude restart"
echo ""
echo "Security Note: The credentials.json file contains sensitive data."
echo "Never share it publicly or commit it to version control."