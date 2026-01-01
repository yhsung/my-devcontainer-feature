# Implementation Guide

Complete step-by-step guide to deploy and use your AI Agent Skills devcontainer feature.

## Project Structure

```
my-devcontainer-feature/
├── .github/
│   └── workflows/
│       └── release.yaml              # Auto-publish to GHCR
├── .devcontainer/
│   └── devcontainer.json             # Development environment
├── src/
│   └── ai-agent-skills/
│       ├── devcontainer-feature.json # Feature definition
│       └── install.sh                # Installation script
├── test/
│   └── ai-agent-skills/
│       └── test.sh                   # Feature tests
├── .gitignore
├── CONTRIBUTING.md
├── EXAMPLE-CONFIG-REPO.md
├── LICENSE
└── README.md
```

## Step-by-Step Implementation

### Phase 1: Setup GitHub Repository

1. **Create GitHub Repository**
   ```bash
   # This repository is already set up
   git remote -v
   ```

2. **Enable GitHub Actions**
   - Go to repository Settings → Actions → General
   - Enable "Read and write permissions" for GITHUB_TOKEN
   - Allow actions to create and approve pull requests

3. **Enable GitHub Container Registry**
   - Go to your GitHub profile → Settings → Developer settings → Personal access tokens
   - Or use the automatic GITHUB_TOKEN (already configured in release.yaml)

### Phase 2: Create Configuration Repository

1. **Create a new repository for your AI configs**
   ```bash
   mkdir my-ai-configs
   cd my-ai-configs
   git init
   ```

2. **Add configuration files**
   ```bash
   # Create basic structure
   mkdir -p prompts/system prompts/tasks mcp-servers

   # Add .clinerules
   cat > .clinerules << 'EOF'
   # AI Agent Rules

   ## Code Standards
   - Follow language-specific best practices
   - Write unit tests for new features
   - Document public APIs

   ## Git Workflow
   - Use conventional commits
   - Create feature branches
   - Require code review
   EOF

   # Commit and push
   git add .
   git commit -m "Initial AI configuration"
   git remote add origin https://github.com/your-username/my-ai-configs.git
   git push -u origin main
   ```

3. **See [EXAMPLE-CONFIG-REPO.md](EXAMPLE-CONFIG-REPO.md) for detailed structure**

### Phase 3: Publish the Feature

1. **Update repository references**

   Edit `README.md` and replace `your-username` with your actual GitHub username.

2. **Commit and push to main**
   ```bash
   git add .
   git commit -m "feat: Initial devcontainer feature implementation

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
   git push origin main
   ```

3. **GitHub Actions will automatically publish**
   - Go to Actions tab to monitor the workflow
   - Once complete, your feature will be available at:
     `ghcr.io/your-username/ai-agent-skills:1`

### Phase 4: Use in Projects

1. **Add to any project's devcontainer.json**

   ```json
   {
     "name": "My Project",
     "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
     "features": {
       "ghcr.io/your-username/ai-agent-skills:1": {
         "configRepoUrl": "https://github.com/your-username/my-ai-configs.git"
       }
     }
   }
   ```

2. **Rebuild the devcontainer**
   - VS Code: Command Palette → "Dev Containers: Rebuild Container"
   - CLI: `devcontainer up --workspace-folder .`

3. **Verify installation**
   ```bash
   # Check environment variables
   echo $AI_SKILLS_PATH

   # Check installed commands
   which setup-ai-configs
   which update-ai-configs

   # Verify symlinks
   ls -la .clinerules
   ```

### Phase 5: Update and Maintain

#### Updating Configuration Repository

```bash
# In your config repo
cd my-ai-configs
# Make changes
git add .
git commit -m "Update AI rules"
git push

# In your devcontainer
update-ai-configs
```

#### Updating the Feature

1. Make changes to `src/ai-agent-skills/`
2. Update version in `devcontainer-feature.json`
3. Commit and push to main
4. GitHub Actions publishes automatically
5. Update projects to use new version: `:2`, `:1.1.0`, etc.

## Advanced Usage Scenarios

### Scenario 1: Team-Wide Configuration

Setup for organizations:

```json
{
  "features": {
    "ghcr.io/your-org/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-org/team-ai-configs.git",
      "configBranch": "production"
    }
  }
}
```

### Scenario 2: Private Configurations with SSH

```json
{
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "git@github.com:your-org/private-configs.git"
    }
  },
  "mounts": [
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,readonly"
  ]
}
```

### Scenario 3: Multi-Environment Support

Different configs for different environments:

```bash
# Create branches in config repo
git checkout -b development
git checkout -b staging
git checkout -b production

# Use in devcontainer.json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-org/configs.git",
      "configBranch": "development"  // or staging, production
    }
  }
}
```

### Scenario 4: Custom Installation Path

```json
{
  "features": {
    "ghcr.io/your-username/ai-agent-skills:1": {
      "configRepoUrl": "https://github.com/your-username/configs.git",
      "targetPath": "/workspace/.ai",
      "enableSymlinks": false
    }
  },
  "postCreateCommand": "ln -s /workspace/.ai/repo/.clinerules .clinerules"
}
```

## Testing Checklist

Before using in production:

- [ ] Feature installs without errors
- [ ] Configuration repository clones successfully
- [ ] Symlinks are created correctly
- [ ] `setup-ai-configs` command works
- [ ] `update-ai-configs` command works
- [ ] Environment variables are set
- [ ] AI agents can read the configurations
- [ ] Private repository authentication works (if applicable)
- [ ] MCP configs sync properly (if used)

## Troubleshooting

### Issue: Feature not found

**Solution**: Ensure GitHub Actions workflow completed successfully
```bash
# Check if package is published
gh api /users/your-username/packages/container/ai-agent-skills
```

### Issue: Clone fails for private repo

**Solution**: Check authentication
```bash
# Test SSH connection
ssh -T git@github.com

# Or verify token
echo $GITHUB_TOKEN
```

### Issue: Symlinks not created

**Solution**: Run setup manually
```bash
setup-ai-configs
# Or check logs
cat /tmp/devcontainer-feature-install.log
```

### Issue: Outdated configs

**Solution**: Pull latest changes
```bash
update-ai-configs
# Or manually
cd $AI_SKILLS_PATH
git pull
```

## Version Management

### Semantic Versioning

- `1.0.0` - Initial release
- `1.0.1` - Patch (bug fixes)
- `1.1.0` - Minor (new features, backwards compatible)
- `2.0.0` - Major (breaking changes)

### Using Versions in Projects

```json
{
  "features": {
    // Latest v1
    "ghcr.io/your-username/ai-agent-skills:1": {},

    // Specific version
    "ghcr.io/your-username/ai-agent-skills:1.0.1": {},

    // Latest (not recommended for production)
    "ghcr.io/your-username/ai-agent-skills:latest": {}
  }
}
```

## Next Steps

1. **Push to GitHub**: Push this repository to GitHub
2. **Create Config Repo**: Set up your AI configurations repository
3. **Wait for Publish**: Monitor GitHub Actions workflow
4. **Test in Project**: Add to a test project and verify
5. **Document**: Add organization-specific notes
6. **Share**: Share with your team

## Support Resources

- [Devcontainer Features Spec](https://containers.dev/implementors/features/)
- [GitHub Actions for Features](https://github.com/devcontainers/action)
- [Claude Code Docs](https://docs.anthropic.com/claude/docs/claude-code)
- [MCP Documentation](https://modelcontextprotocol.io/)

## Example Commands

```bash
# In container - check what's installed
ls -la $AI_SKILLS_PATH

# View available prompts
ls $AI_SKILLS_PATH/prompts

# Check MCP config
cat ~/.config/mcp/config.json

# Update configurations
update-ai-configs

# Re-setup symlinks
setup-ai-configs

# View environment
env | grep AI_
```

## Success Criteria

Your implementation is successful when:

1. ✅ Feature publishes to GHCR automatically
2. ✅ Configuration repo clones on container build
3. ✅ Symlinks are created automatically
4. ✅ AI agents can access configurations
5. ✅ Updates work without rebuilding container
6. ✅ Team members can use in their projects
7. ✅ Documentation is clear and complete

Congratulations! You now have a professional, reusable devcontainer feature for managing AI agent configurations across all your projects.
