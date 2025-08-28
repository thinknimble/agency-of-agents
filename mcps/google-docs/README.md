# Google Docs MCP Server Setup

This directory contains the setup script and credentials for the Google Docs MCP (Model Context Protocol) server integration.

## Quick Setup for Team Members

### Prerequisites
- Node.js (v16 or higher)
- npm
- Claude Code CLI installed
- Git

### Setup Steps

1. **Run the setup script**:
   ```bash
   cd mcps/google-docs
   ./setup-google-docs-mcp.sh
   ```

2. **The script will**:
   - Check prerequisites
   - Install the Google Docs MCP server
   - Use the included OAuth credentials
   - Configure Claude Code automatically
   - Optionally run the authentication flow

3. **If you choose to authenticate during setup**:
   - The script will show a Google authentication URL
   - Grant permissions to access Google Docs and Drive
   - Copy the authorization code from the redirect URL
   - Paste it back into the terminal

4. **Done!** You can now use Google Docs features in Claude

## What's Included

- `credentials.json` - OAuth client credentials (already configured for the team)
- `setup-google-docs-mcp.sh` - Automated setup and installation script

## Security Notes

- The OAuth credentials in this directory are project-specific and safe to share with team members
- Your personal authentication token will be stored securely in your home directory
- Never share your personal token file with others

## Troubleshooting

If you encounter issues:
1. Ensure you have the latest version of Claude Desktop
2. Make sure the Google Docs MCP server is installed in your Claude configuration
3. Try re-running the setup script to re-authenticate

## Manual Configuration (if needed)

If the automatic configuration doesn't work, add this to your `.claude/.mcp.json`:

```json
{
  "mcpServers": {
    "google-docs": {
      "command": "node",
      "args": ["/home/YOUR_USERNAME/.config/claude-code/mcp-servers/google-docs-mcp/dist/server.js"]
    }
  }
}
```