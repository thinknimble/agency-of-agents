<div align="center">

# 🤖 Agency of Agents 🎯

**Transform chaos into clarity with AI-powered workflow automation**

[![Built by ThinkNimble](https://img.shields.io/badge/Built%20by-ThinkNimble-blue)](https://thinknimble.com)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Claude Compatible](https://img.shields.io/badge/Claude-Compatible-purple)](https://claude.ai)

_A collection of specialized Claude sub-agents that transform unstructured business conversations into actionable deliverables for software development teams._

</div>

---

## Overview

This repository provides battle-tested sub-agents that help software agencies and development teams streamline their workflows. Each agent specializes in a specific phase of the client engagement lifecycle - from initial sales conversations through technical implementation.

Built by [ThinkNimble](https://thinknimble.com), these agents are designed to work with Claude (Anthropic's AI assistant) to augment your team's capabilities, not replace them.

## Why Use These Agents?

- **Transform chaos into clarity**: Convert rambling meeting notes into structured tickets
- **Reduce busywork**: Automate the translation between business and technical teams  
- **Maintain consistency**: Standardized outputs across all client engagements
- **Capture institutional knowledge**: Codify your best practices into reusable agents

## Available Agents

### 📊 Sales Prospect Analyzer
Transforms raw meeting notes and transcripts into structured sales intelligence.
- Extracts key business context and pain points
- Identifies stakeholders and decision dynamics
- Produces actionable next steps for sales teams
- [View Details →](.claude/agents/sales-prospect-analyzer.md)

### 🎯 Hypothesis Identifier
Helps founders articulate clear, testable product hypotheses mapped to validation sprints.
- Based on ThinkNimble's startup product strategy framework
- Converts vague ideas into specific, measurable experiments
- Creates 3-sprint validation roadmaps
- [View Details →](.claude/agents/hypothesis-identifier.md)

### ✅ Business Model Validator
Systematically validates business models through structured assessment.
- Evaluates founder background, product viability, and market demand
- Provides quantitative health scores
- Identifies gaps and risks in business models
- [View Details →](.claude/agents/business-model-validator.md)

### 🎫 Meeting to Tickets
Transforms meeting transcripts into prioritized development tickets.
- Analyzes meeting content for actionable items
- Generates tickets with acceptance criteria and effort estimates
- Includes technical implementation notes
- [View Details →](.claude/agents/meeting-to-tickets.md)

### 📄 Google Docs Fetcher
Downloads and converts Google Docs content for local processing.
- Searches and retrieves documents from Google Drive
- Converts to Markdown format with images
- Organizes content into project directories
- [View Details →](.claude/agents/google-docs-fetcher.md)

## Getting Started

### Prerequisites

- [Claude Desktop](https://claude.ai/download) or access to Claude API
- For Google Docs integration: Google OAuth credentials
- For document processing: Python 3.8+ and [uv](https://docs.astral.sh/uv/)

### Using the Agents

1. **Clone this repository**
   ```bash
   git clone https://github.com/thinknimble/agency-of-agents.git
   cd agency-of-agents
   ```

2. **Configure Claude**
   - The agents are defined in `.claude/agents/`
   - Claude will automatically detect and load these agents

3. **Invoke an agent** in Claude using the Task tool:
   ```python
   Task(
       description="Analyze sales call",
       prompt="Here are my notes from the discovery call: [your notes]",
       subagent_type="sales-prospect-analyzer"
   )
   ```

### Example Workflow

See the `projects/` directory for complete examples showing how these agents work together:

1. **Sales team** captures meeting notes → `sales-prospect-analyzer`
2. **Product team** validates the opportunity → `business-model-validator`
3. **Strategy team** defines hypotheses → `hypothesis-identifier`
4. **Engineering team** reviews requirements → `meeting-to-tickets`

## Project Structure

```
agency-of-agents/
├── .claude/              # Claude-specific configurations
│   └── agents/          # Sub-agent definitions
├── projects/            # Example project workflows
│   ├── inventory-management-saas/
│   └── customer-support-ai/
├── mcps/                # MCP integrations
│   └── google-docs/    # Google Docs MCP setup
├── CLAUDE.md           # Claude configuration instructions
├── dump_google_doc.py  # Utility for dumping Google Docs
└── README.md          # This file
```

## Security: Project Data Protection

⚠️ **Important**: To prevent accidental exposure of client data, all new projects in the `projects/` directory are automatically ignored by git. This is a safety measure to ensure sensitive client information is never accidentally committed to public repositories.

### Working with Client Projects

If you want to version control a specific project (after ensuring it contains no sensitive data):

```bash
# Force add a specific project
git add -f projects/your-project-name/

# Or add specific files
git add -f projects/your-project-name/specific-file.md
```

### Example Projects

The repository includes two sanitized example projects that demonstrate the complete workflow:
- `projects/inventory-management-saas/` - Multi-location retail inventory platform
- `projects/customer-support-ai/` - AI-powered support ticket automation

These examples contain no real client data and show how agents work together from initial sales through technical implementation.

## Tools

### Google Doc Dumper Script

A utility script that downloads complete Google Docs without token limits.

```bash
# Install uv if needed
curl -LsSf https://astral.sh/uv/install.sh | sh

# Download a Google Doc
uv run dump_google_doc.py https://docs.google.com/document/d/[doc-id]/edit
```

[Full documentation →](#google-doc-dumper-details)

## Creating Your Own Agents

Agents are defined in `.claude/agents/` using a simple markdown format:

```markdown
---
name: your-agent-name
description: Brief description for Claude's agent selector
color: blue
---

# Your Agent Name

[Agent instructions and context...]
```

See existing agents for examples of well-structured agent definitions.

## 🤝 Community Philosophy

We believe in **"Credit Where Credit's Due"** - a community where:
- Everyone attributes the work they build upon
- Improvements flow back to benefit all agencies
- Knowledge compounds through collaboration

When you use these agents:
- ✅ Give credit to ThinkNimble
- ✅ Share your improvements back
- ✅ Credit others when you build on their work

Not required by license, but it's how we build together.

## Contributing

We welcome contributions! To add a new agent:

1. Create a new `.md` file in `.claude/agents/`
2. Follow the existing agent format
3. Include clear documentation and examples
4. Test with real-world scenarios
5. Submit a pull request

Please ensure all examples use fictional data and no real client information.

### Agent Attribution Format

When creating or enhancing agents, include attribution in the front matter:

```markdown
---
name: your-agent-name
author: YourCompany (https://yourcompany.com)
based-on: original-agent by ThinkNimble (if applicable)
source: https://github.com/yourusername/your-fork
---
```

This helps track the genealogy of ideas and ensures everyone gets recognition for their contributions.

## About ThinkNimble

[ThinkNimble](https://thinknimble.com) is a software development agency that partners with startups and enterprises to build custom software solutions. These agents represent our accumulated knowledge from hundreds of client engagements.

## License

This project uses dual licensing:

- **Code & Scripts**: [Apache License 2.0](LICENSE) - for all Python scripts and executable code
- **Agent Definitions & Documentation**: [CC BY 4.0](LICENSE-DOCS) - for all agent definitions, documentation, and knowledge content

### Attribution Requirements

When using this work, you must:
1. Include the [NOTICE](NOTICE) file in any distribution
2. Provide attribution to ThinkNimble when using agent definitions
3. Link back to this repository: https://github.com/thinknimble/agency-of-agents

See [NOTICE](NOTICE) file for complete attribution requirements.

---

<details>
<summary id="google-doc-dumper-details">📚 Google Doc Dumper - Full Documentation</summary>

### Features

- Downloads complete Google Doc content without token/size limits
- Exports images to a separate subfolder with markdown links
- Uses PEP 723 inline dependencies (managed by `uv`)
- Supports both document IDs and Google Docs URLs
- Automatically generates output filename from document title
- Preserves document structure including tables

### Prerequisites

- Python 3.8+
- [uv](https://docs.astral.sh/uv/) - Python package manager
- Google OAuth credentials (uses the same credentials as MCP)

### How it Works

1. The script includes its dependencies using PEP 723 format
2. When run with `uv run`, it automatically:
   - Creates a temporary virtual environment
   - Installs the required Google API packages
   - Executes the script in that environment
3. Uses OAuth token from `~/.config/claude-code/mcp-servers/google-docs-mcp/token.json`
4. Downloads document content and inline images
5. Saves images to a `<output_name>_images/` subfolder
6. Generates markdown with proper image links

</details>