# AI Agent Skills & Configs - Devcontainer Feature

A professional devcontainer feature for managing AI Agent configurations, prompts, and skills across development environments. Sync your `.clinerules`, MCP configs, custom prompts, and other AI agent settings from a centralized Git repository.

## Features

- **Modular & Version-Controlled**: Install via standard devcontainer features syntax
- **Centralized Configuration**: Clone and sync AI agent configs from any Git repository
- **Automatic Symlinks**: Automatically link config files to workspace and user directories
- **Multi-Agent Support**: Works with Claude CLI, Cline, Roo Code, and other AI agents
- **Easy Updates**: Built-in utilities to refresh configurations from remote repo
- **Privacy-Friendly**: Your config repo can be private (just configure authentication)

## Quick Start

### 1. Add to your devcontainer.json

```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-username/my-ai-configs.git",
      "configBranch": "main",
      "enableSymlinks": true,
      "syncMcpConfigs": true
    }
  }
}
```

### 2. Structure your config repository

Create a repository with your AI agent configurations:

```
my-ai-configs/
├── .clinerules              # Cline/Roo Code rules
├── .clauderc                # Claude CLI configuration
├── prompts/                 # Custom AI prompts
│   ├── code-review.md
│   ├── debugging.md
│   └── documentation.md
└── mcp-servers/             # MCP server configs
    └── config.json
```

### 3. Rebuild your devcontainer

Your AI agent configurations will be automatically cloned and linked when the container is built.

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `configRepoUrl` | string | `""` | Git repository URL containing your AI configs |
| `targetPath` | string | `/usr/local/share/ai-configs` | Container path for storing configs |
| `enableSymlinks` | boolean | `true` | Auto-create symlinks to workspace |
| `configBranch` | string | `main` | Branch to clone from config repo |
| `syncMcpConfigs` | boolean | `true` | Sync MCP server configurations |

## Available Commands

After installation, the following commands are available in your container:

### `setup-ai-configs`
Creates symbolic links from the config repository to your workspace directory.

```bash
setup-ai-configs
```

This command automatically runs when the container starts, but you can run it manually if needed.

### `update-ai-configs`
Pull the latest configurations from your remote repository.

```bash
update-ai-configs
```

Use this to refresh your AI configs without rebuilding the container.

## Environment Variables

The feature sets the following environment variables:

- `AI_SKILLS_PATH`: Path to the cloned configuration repository
- `AI_CONFIGS_REPO`: URL of the configuration repository

## Usage Examples

### Example 1: Basic Usage

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-org/ai-configs.git"
    }
  }
}
```

### Example 2: Custom Configuration

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "git@github.com:your-org/private-ai-configs.git",
      "configBranch": "production",
      "targetPath": "/workspace/.ai-configs",
      "enableSymlinks": true,
      "syncMcpConfigs": true
    }
  },
  "postCreateCommand": "setup-ai-configs"
}
```

### Example 3: Multiple Agent Support

Your config repository can include configurations for multiple AI agents:

```
my-ai-configs/
├── .clinerules                 # For Cline/Roo Code
├── .clauderc                   # For Claude CLI
├── .cursor-rules               # For Cursor AI
├── prompts/
│   ├── system/
│   │   ├── senior-engineer.md
│   │   └── code-reviewer.md
│   └── tasks/
│       ├── refactoring.md
│       └── testing.md
└── mcp-servers/
    ├── config.json
    └── custom-tools/
```

## Private Repository Access

To use a private Git repository, you need to configure authentication:

### Option 1: SSH Key (Recommended)

```json
{
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "git@github.com:your-org/private-configs.git"
    }
  },
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached"
  ]
}
```

### Option 2: GitHub Token

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://${localEnv:GITHUB_TOKEN}@github.com/your-org/private-configs.git"
    }
  }
}
```

## Supported AI Agents

This feature works with:

- **Claude Code** (Official CLI)
- **Cline** (VS Code extension)
- **Roo Code** (VS Code extension)
- **Cursor AI**
- **Aider**
- Any agent that supports `.clinerules`, MCP configs, or custom prompts

## File Mapping

The feature automatically creates symlinks for common AI agent configuration files:

| Source File | Symlink Target | Purpose |
|------------|----------------|---------|
| `.clinerules` | `${workspace}/.clinerules` | Cline/Roo Code rules |
| `.clauderc` | `${workspace}/.clauderc` | Claude CLI config |
| `prompts/` | `${workspace}/.ai-prompts/` | Custom prompt library |
| `mcp-configs/` | `~/.config/mcp/` | MCP server configs |

## Development & Publishing

### Local Testing

To test the feature locally before publishing:

```bash
# Run the test script
./test/ai-agent-skills/test.sh

# Or test in a container
devcontainer features test \
  --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
  --features ai-agent-skills
```

### Publishing to GHCR

The feature is automatically published to GitHub Container Registry when you push to the `main` branch:

1. Push changes to `src/ai-agent-skills/`
2. GitHub Actions automatically builds and publishes
3. Use the feature with version tag: `ghcr.io/your-username/ai-agent-skills:1`

### Versioning

Update the version in [src/ai-agent-skills/devcontainer-feature.json](src/ai-agent-skills/devcontainer-feature.json):

```json
{
  "version": "1.1.0"
}
```

## Benefits

### 1. Version Control
- Tag specific versions of your feature (`:1`, `:1.0.1`)
- Roll back to previous configurations if needed
- Maintain stable development environments

### 2. Privacy & Security
- Feature code can be public while config details remain private
- Support for SSH keys and authentication tokens
- Keep sensitive prompts and rules in private repos

### 3. Team Collaboration
- Share AI agent configurations across your team
- Maintain consistency in AI-assisted development
- Onboard new developers with pre-configured agents

### 4. Multi-Project Support
- Reuse the same feature across multiple projects
- Customize per-project with different config branches
- Maintain organization-wide AI agent standards

## Troubleshooting

### Feature not installing

Check that the repository URL is accessible:
```bash
git clone <your-config-repo-url>
```

### Symlinks not created

Manually run the setup command:
```bash
setup-ai-configs
```

### Private repo access denied

Ensure SSH keys or tokens are properly mounted and configured in your devcontainer.json.

### MCP configs not syncing

Verify that your config repository has the `mcp-servers/` directory structure.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes
4. Submit a pull request

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

## Resources

- [Devcontainer Features Specification](https://containers.dev/implementors/features/)
- [Publishing Features to GHCR](https://github.com/devcontainers/feature-starter)
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io/)

## Support

For issues and questions:
- Open an issue on GitHub
- Check existing discussions
- Review the troubleshooting section above
