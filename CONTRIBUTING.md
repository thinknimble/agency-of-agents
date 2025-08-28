# Contributing to Agency of Agents

Thank you for your interest in contributing to Agency of Agents! We believe in "Credit Where Credit's Due" - a community where everyone's contributions are recognized and valued.

## 🤝 Our Community Philosophy

- **Attribution Matters**: Everyone gets credit for their work
- **Knowledge Compounds**: Your improvements help all agencies
- **Quality Over Quantity**: Well-crafted agents over many mediocre ones
- **Real-World Testing**: Agents should solve actual problems

## 📝 Ways to Contribute

### 1. Create New Agents
Build agents that solve new workflow challenges in software agencies.

### 2. Enhance Existing Agents
Improve core agents with new capabilities or better prompts.

### 3. Share Use Cases
Document how you're using agents in your workflow.

### 4. Report Issues
Help us identify bugs or areas for improvement.

### 5. Improve Documentation
Make the project more accessible to newcomers.

## 🚀 Creating a New Agent

### Step 1: Design Your Agent

Before coding, consider:
- What specific problem does it solve?
- Who is the target user?
- What makes it different from existing agents?
- What real-world scenario has it been tested on?

### Step 2: Use the Agent Template

Create your agent in `.claude/agents/your-agent-name.md`:

```markdown
---
name: your-agent-name
author: YourName/Company (https://yourwebsite.com)
version: 1.0
based-on: original-agent by ThinkNimble (if applicable)
source: https://github.com/yourusername/your-fork
license: CC BY 4.0
description: Brief description for Claude's agent selector. Include examples of when to use this agent.
color: blue
---

# Agent Name

## Purpose
Clear explanation of what this agent does and why it's valuable.

## Core Capabilities
- Capability 1
- Capability 2
- Capability 3

## Instructions
[Detailed instructions for the agent's behavior]

## Example Usage
[Provide 2-3 concrete examples]

## Output Format
[Describe the expected output structure]

## Testing
[How you've tested this agent]
```

### Step 3: Test Your Agent

- Test with real-world scenarios
- Ensure it handles edge cases
- Verify it produces consistent results
- Use only fictional data in examples

### Step 4: Update the Registry

Add your agent to `REGISTRY.md`:
1. Add to the Community Agents table
2. Update statistics
3. Add to appropriate category

### Step 5: Submit Your Pull Request

1. Fork the repository
2. Create a feature branch: `git checkout -b add-agent-name`
3. Commit your changes: `git commit -m "Add [agent-name] agent for [purpose]"`
4. Push to your fork: `git push origin add-agent-name`
5. Open a Pull Request

## 🔧 Enhancing Existing Agents

### For Minor Improvements
- Fix typos or clarify instructions
- Add new examples
- Improve error handling

### For Major Enhancements
1. Open an issue first to discuss the enhancement
2. Maintain backward compatibility when possible
3. Update version number in agent metadata
4. Add your attribution using "enhanced-by" field:

```markdown
---
name: enhanced-agent
author: ThinkNimble (https://thinknimble.com)
enhanced-by: YourName (https://yoursite.com)
version: 1.1
---
```

## 📋 Pull Request Guidelines

### PR Title Format
- New agent: `feat: Add [agent-name] agent`
- Enhancement: `enhance: Improve [agent-name] [what you improved]`
- Bug fix: `fix: Fix [issue] in [agent-name]`
- Docs: `docs: Update [what you updated]`

### PR Description Template
```markdown
## What This PR Does
Brief description of changes

## Why This Is Needed
Problem this solves or improvement this brings

## How It Was Tested
Description of testing performed

## Agent Attribution
- [ ] Added author metadata to agent file
- [ ] Updated REGISTRY.md
- [ ] Used fictional data in examples

## Checklist
- [ ] Followed agent template format
- [ ] Tested with real scenarios
- [ ] No client/sensitive data included
- [ ] Documentation is clear and complete
```

## 🎯 Code of Conduct

### Do's
- ✅ Give credit to others when building on their work
- ✅ Use respectful and inclusive language
- ✅ Accept constructive feedback gracefully
- ✅ Focus on what's best for the community
- ✅ Test thoroughly before submitting

### Don'ts
- ❌ Include real client data or sensitive information
- ❌ Submit untested agents
- ❌ Remove or modify others' attribution
- ❌ Use aggressive or dismissive language
- ❌ Submit low-effort or duplicate agents

## 🐛 Reporting Issues

### Before Opening an Issue
1. Check existing issues to avoid duplicates
2. Try to reproduce the problem
3. Gather relevant information

### Issue Template
```markdown
**Agent Name:** [Which agent has the issue]
**Issue Type:** [Bug/Enhancement/Question]

**Description:**
[Clear description of the issue]

**Steps to Reproduce:**
1. [First step]
2. [Second step]
3. [What happens]

**Expected Behavior:**
[What should happen instead]

**Environment:**
- Claude version: [e.g., Claude Desktop]
- OS: [e.g., macOS, Windows, Linux]
```

## 💡 Feature Requests

We love new ideas! To propose a new agent or feature:

1. Open an issue with `[Feature Request]` in the title
2. Describe the problem it solves
3. Provide use cases
4. Suggest implementation approach (if you have one)

## 🏆 Recognition

Contributors are recognized in multiple ways:
- Listed in agent metadata (permanent attribution)
- Added to REGISTRY.md
- Mentioned in release notes
- Potential featured case studies

## 📚 Resources

- [Agent Registry](REGISTRY.md) - See all available agents
- [License Information](LICENSE) - Understand the dual licensing
- [ThinkNimble](https://thinknimble.com) - Learn more about us

## 💬 Getting Help

- **Questions**: Open an issue with `[Question]` tag
- **Discussions**: Use GitHub Discussions for general topics
- **Contact**: Open an issue for project-related contact

## 🎉 Thank You!

Every contribution, no matter how small, helps make Agency of Agents better for the entire community. We appreciate your time and effort in improving this project!

---

*By contributing, you agree to license your contributions under the same licenses as the project (Apache 2.0 for code, CC BY 4.0 for agent definitions).*