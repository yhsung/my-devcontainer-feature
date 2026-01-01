# Deployment Checklist

Use this checklist to deploy your AI Agent Skills devcontainer feature.

## Pre-Deployment

- [x] Project structure created
- [x] Core files implemented
  - [x] `src/ai-agent-skills/devcontainer-feature.json`
  - [x] `src/ai-agent-skills/install.sh`
  - [x] `test/ai-agent-skills/test.sh`
  - [x] `.github/workflows/release.yaml`
- [x] Documentation complete
  - [x] README.md
  - [x] IMPLEMENTATION-GUIDE.md
  - [x] EXAMPLE-CONFIG-REPO.md
  - [x] CONTRIBUTING.md
  - [x] PROJECT-SUMMARY.md
- [x] Scripts are executable
- [x] License file included

## Customization Required

Before deploying, update these items with your information:

### 1. Update README.md
- [ ] Replace `your-username` with your GitHub username (appears ~10 times)
- [ ] Replace `your-org` with your organization name (if applicable)
- [ ] Update repository URLs in examples
- [ ] Add your name/organization to copyright if desired

### 2. Update devcontainer-feature.json
- [ ] Update `documentationURL` with your repository URL
- [ ] Verify version number (`1.0.0` is good for initial release)

### 3. Update IMPLEMENTATION-GUIDE.md
- [ ] Replace `your-username` with your GitHub username
- [ ] Update example repository URLs

### 4. Update EXAMPLE-CONFIG-REPO.md
- [ ] Replace `your-org` with your organization/username
- [ ] Customize example configurations if desired

## GitHub Repository Setup

- [ ] Push this repository to GitHub
  ```bash
  git remote add origin https://github.com/YOUR-USERNAME/my-devcontainer-feature.git
  git branch -M main
  git push -u origin main
  ```

- [ ] Enable GitHub Actions
  - [ ] Go to Settings → Actions → General
  - [ ] Select "Allow all actions and reusable workflows"
  - [ ] Under "Workflow permissions", select "Read and write permissions"
  - [ ] Check "Allow GitHub Actions to create and approve pull requests"
  - [ ] Save

- [ ] Verify repository is public (or configure GHCR for private repos)

## Create Configuration Repository

- [ ] Create a new repository for AI configurations (e.g., `my-ai-configs`)
- [ ] Add basic structure:
  ```bash
  mkdir -p my-ai-configs/prompts/system my-ai-configs/prompts/tasks my-ai-configs/mcp-servers
  cd my-ai-configs
  
  # Create .clinerules
  cat > .clinerules << 'RULES'
  # AI Agent Rules
  
  ## Code Standards
  - Follow language-specific best practices
  - Write tests for new features
  - Document public APIs
  
  ## Git Workflow
  - Use conventional commits
  - Create feature branches
  RULES
  
  git init
  git add .
  git commit -m "Initial AI configuration"
  git remote add origin https://github.com/YOUR-USERNAME/my-ai-configs.git
  git push -u origin main
  ```

- [ ] Make repository public or set up authentication for private access

## First Deployment

- [ ] Push feature repository to trigger GitHub Actions
  ```bash
  git add .
  git commit -m "feat: Initial release of AI Agent Skills feature"
  git push origin main
  ```

- [ ] Monitor GitHub Actions workflow
  - [ ] Go to Actions tab in your repository
  - [ ] Watch the "Release Devcontainer Features" workflow
  - [ ] Verify it completes successfully (green checkmark)

- [ ] Verify package published to GHCR
  - [ ] Go to your GitHub profile
  - [ ] Click "Packages" tab
  - [ ] Look for `ai-agent-skills` package
  - [ ] Click on it and verify version `1` is published

## Testing

- [ ] Create a test project
  ```bash
  mkdir test-project
  cd test-project
  mkdir .devcontainer
  ```

- [ ] Add devcontainer.json
  ```json
  {
    "name": "Test Project",
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
      "ghcr.io/YOUR-USERNAME/ai-agent-skills:1": {
        "configRepoUrl": "https://github.com/YOUR-USERNAME/my-ai-configs.git"
      }
    }
  }
  ```

- [ ] Build and test the devcontainer
  - [ ] Open in VS Code
  - [ ] Rebuild container
  - [ ] Verify no errors during build

- [ ] Verify installation
  ```bash
  # In the container
  echo $AI_SKILLS_PATH
  which setup-ai-configs
  which update-ai-configs
  ls -la .clinerules
  ```

- [ ] Test utility commands
  ```bash
  setup-ai-configs
  update-ai-configs
  ```

## Post-Deployment

- [ ] Update test project to use your feature
- [ ] Share with team members
- [ ] Create example configuration repository template
- [ ] Monitor for issues or feedback
- [ ] Plan improvements for future versions

## Version Updates

When you need to release a new version:

- [ ] Update `version` in `src/ai-agent-skills/devcontainer-feature.json`
- [ ] Update CHANGELOG or release notes
- [ ] Commit changes
  ```bash
  git add src/ai-agent-skills/devcontainer-feature.json
  git commit -m "chore: bump version to X.Y.Z"
  git push origin main
  ```
- [ ] GitHub Actions will automatically publish the new version
- [ ] Update projects to use new version (`:2`, `:1.1.0`, etc.)

## Success Criteria

Your deployment is successful when:

- [x] All files created and properly formatted
- [ ] GitHub Actions workflow runs successfully
- [ ] Feature package appears in GHCR
- [ ] Test project builds without errors
- [ ] Configuration repository clones successfully
- [ ] Symlinks are created automatically
- [ ] `setup-ai-configs` command works
- [ ] `update-ai-configs` command works
- [ ] AI agents can read configurations
- [ ] Team members can use the feature

## Troubleshooting

### Workflow fails
- Check GitHub Actions permissions are set correctly
- Verify repository is public or GHCR is configured for private
- Check logs in Actions tab for specific errors

### Feature not found
- Wait a few minutes after workflow completes
- Check package visibility in GHCR settings
- Verify you're using correct username in feature URL

### Clone fails in test
- Verify config repository URL is correct
- Check repository is public or authentication is configured
- Test `git clone` manually from container

### Symlinks not created
- Run `setup-ai-configs` manually
- Check `$AI_SKILLS_PATH` is set
- Verify install.sh executed successfully (check container build logs)

## Next Steps After Successful Deployment

1. Document your specific AI agent configurations
2. Share the feature URL with your team
3. Create organization-specific documentation
4. Set up branch strategy for config repo (dev/staging/prod)
5. Gather feedback and plan improvements
6. Consider contributing improvements back to the project

---

**Ready to deploy? Start with the "Customization Required" section above!**
