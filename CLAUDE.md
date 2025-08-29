# Claude Instructions for Agency of Agents

## Project Overview
This project defines sub-agents to assist with various workflows at a software development agency, including:
- Hypothesis Identifier (based on ThinkNimble framework)
- Sales Summaries
- Business Quality Scoring
- And more specialized agents

## Project Structure
```
agency-of-agents/
├── .claude/                  # Claude-specific configurations
│   └── agents/              # Sub-agent definitions
│       ├── business-model-validator.md
│       ├── github-issue-creator.md
│       ├── github-milestone-analyzer.md
│       ├── google-docs-fetcher.md
│       ├── hypothesis-identifier.md
│       ├── meeting-to-tickets.md
│       └── sales-prospect-analyzer.md
├── projects/                 # Project-specific documentation
│   ├── inventory-management-saas/  # Example: SaaS inventory platform
│   └── customer-support-ai/        # Example: AI customer support tool
├── mcps/                    # MCP integrations
│   └── google-docs/         # Google Docs MCP setup
│       ├── credentials.json
│       ├── setup-google-docs-mcp.sh
│       └── README.md
├── workflows/               # Workflow implementations (planned)
├── tests/                   # Test suite (planned)
├── dump_google_doc.py       # Google Doc dumper utility
├── CLAUDE.md               # This file
├── README.md               # Project overview
└── ThinkNimble_Hypothesis_Identifier_GPT_Context.md
```

## Available Sub-Agents

### 1. google-docs-fetcher
**Purpose**: Downloads Google Docs content for local work and converts to Markdown format.

**When to use**:
- Fetching specific Google Docs by name or ID
- Searching for documents in Google Drive and downloading them
- Converting Google Docs to Markdown format with images
- Organizing downloaded content into appropriate project directories

**Example usage**:
```
Task(description="Fetch project docs", prompt="Get all the design documents for the inventory management project", subagent_type="google-docs-fetcher")
```

### 2. sales-prospect-analyzer
**Purpose**: Transforms raw meeting notes and transcripts into structured sales intelligence.

**When to use**:
- After sales discovery calls or meetings
- When processing unstructured notes from prospect interactions
- To prepare for sales review and follow-up meetings
- Before hypothesis testing and business quality scoring

**Example usage**:
```
Task(description="Analyze prospect meeting", prompt="Here are my notes from the meeting with TechCorp: [raw notes]", subagent_type="sales-prospect-analyzer")
```

**Output**: Creates `sales-prospect-analysis.md` in the appropriate project folder.

### 3. business-model-validator
**Purpose**: Systematically validates business models through structured assessment.

**When to use**:
- Evaluating startup business model viability
- Assessing founder background and expertise
- Scoring product-market fit and traction
- Identifying critical assumptions and hypotheses to test

**Example usage**:
```
Task(description="Validate business model", prompt="I need to validate this startup's business model - they claim to have a SaaS product for restaurants", subagent_type="business-model-validator")
```

**Output**: Provides quantitative health score and prioritized recommendations.

### 4. hypothesis-identifier
**Purpose**: Helps founders articulate clear, testable product hypotheses and map them to validation sprints.

**When to use**:
- After initial business model validation
- To determine which assumptions to test first
- Planning experiments and validation strategies
- Risk assessment and mitigation planning

**Note**: Based on the ThinkNimble framework documented in `ThinkNimble_Hypothesis_Identifier_GPT_Context.md`

### 5. meeting-to-tickets
**Purpose**: Transform meeting notes and transcripts into actionable development tickets with proper prioritization and technical specifications.

**When to use**:
- After team meetings or client check-ins
- Processing meeting transcripts from Google Meet, Zoom, etc.
- Converting strategic discussions into tactical development work
- Creating sprint backlogs from planning sessions

**Example usage**:
```
Task(description="Convert meeting to tickets", prompt="Convert this client check-in transcript into development tickets. Repository: github.com/example/project", subagent_type="meeting-to-tickets")
```

**Output**: Creates a markdown file with prioritized development tickets including acceptance criteria, effort estimates, and technical notes.

### 6. github-issue-creator
**Purpose**: Transform PRDs into GitHub milestones and issues with strategic ROI-driven focus.

**When to use**:
- Converting Product Requirements Documents (PRDs) into actionable work items
- Creating strategic milestones that solve risky business hypotheses  
- Breaking down complex features into day-sized development issues
- Connecting features to business outcomes and user patterns

**Example usage**:
```
Task(description="Convert PRD to GitHub issues", prompt="Convert this PRD into GitHub milestones and issues for our development team. Focus on the user onboarding flow. Repository: github.com/example/project", subagent_type="github-issue-creator")
```

**Output**: Creates structured document with strategic milestones (1-2 weeks scope) and day-sized issues with business context, acceptance criteria, and potential roadblocks.

### 7. github-milestone-analyzer
**Purpose**: Analyze GitHub milestones and issues for patterns, estimation accuracy, and outcome alignment to improve future issue creation.

**When to use**:
- Reviewing sprint performance and issue quality
- Identifying patterns in time overruns or scope changes
- Analyzing estimation accuracy and outcome mismatches
- Improving issue creation guidelines based on delivery data
- Detecting excessive clarification needs in issues

**Example usage**:
```
Task(description="Analyze GitHub issues", prompt="Analyze our GitHub repository for the last 30 days focusing on issue estimation accuracy and scope changes. Repository: github.com/example/project", subagent_type="github-milestone-analyzer")
```

**Output**: Comprehensive analysis report with estimation accuracy metrics, outcome alignment assessment, clarification pattern analysis, and actionable recommendations for improving issue creation guidelines.

## Available Tools

### Google Doc Dumper Script (`dump_google_doc.py`)
- Python script that dumps complete Google Doc content without token limits
- Uses PEP 723 inline dependencies (requires `uv`)
- Supports document IDs and Google Docs URLs
- Usage: `uv run dump_google_doc.py <doc_id_or_url> [output_file]`

### Google Docs MCP Integration
- Full Google Docs and Drive API access through MCP
- Setup script available at `mcps/google-docs/setup-google-docs-mcp.sh`
- Provides document creation, editing, formatting, and Drive operations

## Development Guidelines
1. Each sub-agent should have a clear, focused purpose
2. Agents should be modular and reusable
3. Document agent capabilities and interfaces clearly
4. Include examples of agent usage in documentation

## Testing
Run tests with: `npm test` (once configured)

## Linting
Run linting with: `npm run lint` (once configured)