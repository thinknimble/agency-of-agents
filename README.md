# Agency of Agents

A collection of specialized sub-agents designed to streamline workflows at a software development agency.

## Overview

This project provides a framework for creating and managing sub-agents that handle specific tasks within a software development agency context. Each agent is designed to excel at a particular workflow or analysis task.

## Available Agents

### Hypothesis Prioritizer Agent
Helps founders articulate clear, testable product hypotheses and map them to 3 sprints of validation work. Based on ThinkNimble's startup product strategy framework. [Learn more →](.claude/agents/hypothesis-prioritizer.md)

## Planned Agents

- **Sales Summary Agent**: Analyzes and summarizes sales data, conversations, and opportunities
- **Business Quality Scoring Agent**: Evaluates and scores business processes, code quality, and project health
- **Additional specialized agents**: To be defined based on agency needs

## Getting Started

(To be completed as we build out the project structure)

## Project Structure

```
agency-of-agents/
├── .claude/          # Claude-specific configurations
│   └── agents/       # Sub-agent definitions
├── workflows/        # Workflow implementations
├── tests/           # Test suite
├── mcps/            # MCP integrations
│   └── google-docs/ # Google Docs MCP setup
├── projects/        # Project-specific documentation
├── CLAUDE.md        # Instructions for Claude
├── dump_google_doc.py # Google Doc dumper utility
└── README.md        # This file
```

## Security: Project Data Protection

⚠️ **Important**: To prevent accidental exposure of client data, all new projects in the `projects/` directory are automatically ignored by git. This is a safety measure to ensure sensitive client information is never accidentally committed to public repositories.

### Adding Projects to Git

If you want to version control a specific project (after ensuring it contains no sensitive data):

```bash
# Force add a specific project
git add -f projects/your-project-name/

# Or add specific files
git add -f projects/your-project-name/specific-file.md
```

### Example Projects

The repository includes two example projects that demonstrate the workflow:
- `projects/inventory-management-saas/` - Example SaaS inventory platform engagement
- `projects/customer-support-ai/` - Example AI customer support tool engagement

These examples are explicitly included in version control and contain no real client data.

## Tools

### Google Doc Dumper Script

A Python script that dumps the full contents of a Google Doc to a local file, bypassing token limits. Uses the same OAuth credentials as the MCP Google Docs integration.

#### Features

- Downloads complete Google Doc content without token/size limits
- Exports images to a separate subfolder with markdown links
- Uses PEP 723 inline dependencies (managed by `uv`)
- Supports both document IDs and Google Docs URLs
- Automatically generates output filename from document title
- Preserves document structure including tables

#### Prerequisites

- Python 3.8+
- [uv](https://docs.astral.sh/uv/) - Python package manager
- Google OAuth credentials (uses the same credentials as MCP)

#### Installation

No manual dependency installation needed! The script uses `uv` to automatically manage its dependencies.

```bash
# Install uv if you haven't already
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Usage

```bash
# Using document ID
uv run dump_google_doc.py 1vlK2Rvwk9VbvypXjBSp2gfLdKLlGRLYAf8iyUP8p7lA

# Using Google Docs URL
uv run dump_google_doc.py https://docs.google.com/document/d/1vlK2Rvwk9VbvypXjBSp2gfLdKLlGRLYAf8iyUP8p7lA/edit

# Specify output filename
uv run dump_google_doc.py 1vlK2Rvwk9VbvypXjBSp2gfLdKLlGRLYAf8iyUP8p7lA output.md
```

#### How it Works

1. The script includes its dependencies using PEP 723 format at the top of the file
2. When run with `uv run`, it automatically:
   - Creates a temporary virtual environment
   - Installs the required Google API packages
   - Executes the script in that environment
3. Uses the OAuth token from `~/.config/claude-code/mcp-servers/google-docs-mcp/token.json`
4. If no token exists, initiates OAuth flow using credentials from `mcps/google-docs/credentials.json`
5. Downloads document content and inline images
6. Saves images to a `<output_name>_images/` subfolder
7. Generates markdown with proper image links (e.g., `![Image 1](subfolder/image_1.png)`)

## Contributing

Each agent should be well-documented with clear interfaces and usage examples.

## License

(To be determined)