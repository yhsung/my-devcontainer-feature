# Example Configuration Repository Structure

This guide shows how to structure your AI agent configuration repository that will be used with this devcontainer feature.

## Recommended Structure

```
my-ai-configs/
├── README.md
├── .clinerules                 # Cline/Roo Code configuration
├── .clauderc                   # Claude CLI settings (optional)
│
├── prompts/                    # Custom prompt library
│   ├── system/                 # System-level prompts
│   │   ├── senior-engineer.md
│   │   ├── code-reviewer.md
│   │   ├── tech-lead.md
│   │   └── security-expert.md
│   │
│   ├── tasks/                  # Task-specific prompts
│   │   ├── refactoring.md
│   │   ├── testing.md
│   │   ├── documentation.md
│   │   └── debugging.md
│   │
│   └── languages/              # Language-specific prompts
│       ├── python.md
│       ├── typescript.md
│       ├── rust.md
│       └── go.md
│
├── mcp-servers/                # MCP (Model Context Protocol) configs
│   ├── config.json             # Main MCP configuration
│   └── custom-tools/           # Custom MCP tools
│       └── README.md
│
└── templates/                  # Project templates and snippets
    ├── api-endpoint.md
    ├── react-component.md
    └── unit-test.md
```

## Example Files

### .clinerules

```markdown
# AI Agent Rules for My Team

## Code Style
- Use TypeScript strict mode
- Prefer functional components in React
- Follow Airbnb style guide for JavaScript
- Use Prettier for formatting

## Testing Requirements
- Write unit tests for all new functions
- Maintain >80% code coverage
- Use Jest for testing
- Include integration tests for API endpoints

## Documentation
- Add JSDoc comments to all public functions
- Update README.md when adding features
- Include examples in documentation

## Security
- Never commit secrets or API keys
- Validate all user input
- Use parameterized queries for database access
- Follow OWASP top 10 guidelines

## Git Workflow
- Use conventional commits (feat:, fix:, docs:, etc.)
- Create feature branches from main
- Squash commits before merging
- Require code review before merging
```

### prompts/system/senior-engineer.md

```markdown
# Senior Engineer Persona

You are a senior software engineer with 10+ years of experience.

## Your Approach
- Think through problems systematically before coding
- Consider performance, scalability, and maintainability
- Write clean, well-tested code
- Provide thoughtful code reviews
- Mentor junior developers through explanations

## Your Expertise
- Software architecture and design patterns
- Performance optimization
- Testing strategies (unit, integration, e2e)
- CI/CD and DevOps practices
- Security best practices

## Your Communication Style
- Clear and concise explanations
- Use industry-standard terminology
- Provide rationale for technical decisions
- Suggest alternatives when appropriate
- Ask clarifying questions when requirements are ambiguous
```

### mcp-servers/config.json

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "database": {
      "command": "npx",
      "args": ["-y", "@your-org/mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### prompts/tasks/refactoring.md

```markdown
# Refactoring Task Prompt

When refactoring code:

1. **Understand First**
   - Read and understand the existing code thoroughly
   - Identify the purpose and requirements
   - Note any tests that need to be maintained

2. **Plan the Refactor**
   - Identify code smells and anti-patterns
   - Propose improvements with rationale
   - Consider backwards compatibility

3. **Execute Incrementally**
   - Make small, focused changes
   - Run tests after each change
   - Maintain functionality throughout

4. **Improve Quality**
   - Reduce complexity and duplication
   - Improve naming and structure
   - Add missing tests
   - Update documentation

5. **Verify**
   - All tests pass
   - No new warnings or errors
   - Performance is maintained or improved
   - Code review guidelines are met
```

## Usage in Projects

### Basic Usage

In your project's `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-org/my-ai-configs.git"
    }
  }
}
```

### Project-Specific Overrides

You can still have project-specific `.clinerules` that override or extend the global ones:

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-org/my-ai-configs.git",
      "enableSymlinks": false
    }
  },
  "postCreateCommand": "cp /usr/local/share/ai-configs/repo/.clinerules .clinerules && echo '\n# Project-specific rules\n- Use Python 3.11+' >> .clinerules"
}
```

### Team vs Personal Configs

You can maintain both team-wide and personal configurations:

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/company/team-ai-configs.git",
      "targetPath": "/usr/local/share/team-configs"
    },
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/yourname/personal-ai-configs.git",
      "targetPath": "/usr/local/share/personal-configs"
    }
  }
}
```

Note: Devcontainer features don't support multiple instances yet, so you'd need to manually merge or use postCreateCommand.

## Best Practices

1. **Version Control**: Use Git tags for stable versions of your configs
2. **Documentation**: Include README.md explaining your configuration choices
3. **Organization**: Group related prompts and configs logically
4. **Privacy**: Use private repositories for company-specific or sensitive configurations
5. **Sharing**: Create public templates for common use cases
6. **Testing**: Validate prompts and rules work as expected before committing
7. **Collaboration**: Use branches for experimental configurations
8. **Consistency**: Maintain consistent formatting across all config files

## Template Repository

You can create a template repository on GitHub to help others get started:

1. Create a new repository: `ai-agent-configs-template`
2. Add the structure above with example files
3. Mark it as a template repository in GitHub settings
4. Share it with your team or community

## Private Repository Setup

For private configuration repositories:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "git@github.com:your-org/private-ai-configs.git"
    }
  },
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,readonly"
  ]
}
```

This will mount your SSH keys into the container for authentication.
