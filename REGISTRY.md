# 📚 Agent Registry

A comprehensive registry of all agents in the Agency of Agents ecosystem.

## Core Agents (by ThinkNimble)

These are the original agents developed and maintained by ThinkNimble.

| Agent Name | Version | Purpose | Category | Links |
|------------|---------|---------|----------|-------|
| `sales-prospect-analyzer` | v1.0 | Transform raw meeting notes into structured sales intelligence | Sales | [View Agent](.claude/agents/sales-prospect-analyzer.md) |
| `hypothesis-identifier` | v1.0 | Articulate testable product hypotheses and validation sprints | Strategy | [View Agent](.claude/agents/hypothesis-identifier.md) |
| `business-model-validator` | v1.0 | Systematically validate business models with quantitative scoring | Validation | [View Agent](.claude/agents/business-model-validator.md) |
| `meeting-to-tickets` | v1.0 | Convert meeting transcripts into prioritized development tickets | Development | [View Agent](.claude/agents/meeting-to-tickets.md) |
| `google-docs-fetcher` | v1.0 | Download and convert Google Docs for local processing | Utilities | [View Agent](.claude/agents/google-docs-fetcher.md) |

## Community Agents

Agents contributed by the community. To add your agent, submit a PR with the agent file and update this registry.

| Agent Name | Version | Purpose | Author | Based On | PR | Links |
|------------|---------|---------|--------|----------|-----|-------|
| _Coming soon_ | - | - | - | - | - | - |

## Agent Statistics

- **Total Core Agents:** 5
- **Total Community Agents:** 0
- **Total Contributors:** 1
- **Categories:** Sales, Strategy, Validation, Development, Utilities

## How to Contribute an Agent

1. **Create Your Agent:**
   - Fork this repository
   - Add your agent to `.claude/agents/your-agent-name.md`
   - Follow the attribution format:
   ```markdown
   ---
   name: your-agent-name
   author: YourCompany (https://yourcompany.com)
   version: 1.0
   based-on: original-agent by ThinkNimble (if applicable)
   source: https://github.com/yourusername/your-fork
   license: CC BY 4.0
   description: Clear description of what your agent does
   color: choose-a-color
   ---
   ```

2. **Test Your Agent:**
   - Ensure it works with Claude
   - Include example usage
   - Use fictional data only

3. **Submit Your PR:**
   - Update this REGISTRY.md file
   - Add your agent to the Community Agents table
   - Include a brief description of your use case

4. **Get Recognition:**
   - Your contribution will be listed here
   - You'll be added as a contributor
   - Your company/name gets attribution

## Agent Categories

### Sales & Marketing
- `sales-prospect-analyzer` - Sales intelligence from meetings

### Product Strategy
- `hypothesis-identifier` - Product hypothesis validation
- `business-model-validator` - Business model assessment

### Development
- `meeting-to-tickets` - Meeting to ticket conversion

### Utilities
- `google-docs-fetcher` - Document retrieval and conversion

### Coming Soon (Ideas Welcome!)
- Customer journey mapper
- Sprint retrospective analyzer
- Technical debt assessor
- User story generator
- API documentation builder
- Code review assistant

## Version History

### v1.0 (January 2025)
- Initial release with 5 core agents
- Established attribution format
- Created community contribution guidelines

## License

All agents in this registry are licensed under CC BY 4.0, requiring attribution to their respective authors. See individual agent files for specific attribution requirements.

## Maintained By

This registry is maintained by [ThinkNimble](https://thinknimble.com). For questions or suggestions, please open an issue or submit a PR.

---

*Last Updated: January 2025*