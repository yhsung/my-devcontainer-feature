# Contributing to AI Agent Skills Feature

Thank you for your interest in contributing to this devcontainer feature!

## Development Setup

1. Clone the repository
2. Make changes in `src/ai-agent-skills/`
3. Test your changes locally

## Testing

Run the test script to validate your changes:

```bash
./test/ai-agent-skills/test.sh
```

Or test in a real devcontainer:

```bash
devcontainer features test \
  --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
  --features ai-agent-skills
```

## Making Changes

1. **Fork** the repository
2. **Create a branch** for your feature or bugfix
3. **Make your changes** in `src/ai-agent-skills/`
4. **Test thoroughly** using the test script
5. **Update documentation** if needed
6. **Commit** with clear, descriptive messages
7. **Submit a pull request**

## Code Guidelines

- Keep `install.sh` POSIX-compliant (use `/bin/sh`, not `/bin/bash`)
- Add error handling for all external commands
- Include descriptive echo messages for user feedback
- Update `devcontainer-feature.json` version when making changes
- Document any new options in README.md

## Pull Request Process

1. Ensure all tests pass
2. Update the README.md with details of changes
3. Update the version in `devcontainer-feature.json` following semver
4. The PR will be merged once approved by maintainers

## Versioning

We use semantic versioning:
- **MAJOR**: Breaking changes
- **MINOR**: New features, backwards-compatible
- **PATCH**: Bug fixes

## Questions?

Open an issue for any questions or discussions.
