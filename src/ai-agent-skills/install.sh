#!/bin/sh
set -e

# Parse options from devcontainer-feature.json
CONFIG_REPO_URL="${CONFIGREPOURL:-https://github.com/yhsung/ai-agent-config}"
TARGET_PATH="${TARGETPATH:-/usr/local/share/ai-configs}"
ENABLE_SYMLINKS="${ENABLESYMLINKS:-true}"
CONFIG_BRANCH="${CONFIGBRANCH:-main}"
SYNC_MCP_CONFIGS="${SYNCMCPCONFIGS:-true}"

echo "=========================================="
echo "Activating AI Agent Skills Feature..."
echo "=========================================="

# Ensure git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Installing git..."
    apt-get update && apt-get install -y git
fi

# Create target directory
echo "Creating target directory: ${TARGET_PATH}"
mkdir -p "${TARGET_PATH}"

# Clone configuration repository if URL is provided
if [ -n "$CONFIG_REPO_URL" ]; then
    echo "Cloning skills from: ${CONFIG_REPO_URL}"
    echo "Branch: ${CONFIG_BRANCH}"

    # Clone with error handling
    if git clone --branch "${CONFIG_BRANCH}" "${CONFIG_REPO_URL}" "${TARGET_PATH}/repo" 2>&1; then
        echo "✓ Successfully cloned configuration repository"
    else
        echo "⚠ Warning: Failed to clone repository. You may need to configure authentication."
        echo "  Repository: ${CONFIG_REPO_URL}"
        exit 0  # Don't fail the container build
    fi

    # Set up environment variables
    echo "export AI_SKILLS_PATH=${TARGET_PATH}/repo" >> /etc/bash.bashrc
    echo "export AI_CONFIGS_REPO=${CONFIG_REPO_URL}" >> /etc/bash.bashrc

    # Create symbolic links if enabled
    if [ "$ENABLE_SYMLINKS" = "true" ]; then
        echo "Setting up symbolic links..."

        # Create a setup script for runtime symlink creation
        cat > /usr/local/bin/setup-ai-configs <<'SETUP_SCRIPT'
#!/bin/bash
# This script creates symlinks in the workspace directory
# It's called from postCreateCommand or can be run manually

AI_SKILLS_PATH="${AI_SKILLS_PATH:-/usr/local/share/ai-configs/repo}"
WORKSPACE_DIR="${1:-/workspaces}"

if [ ! -d "$AI_SKILLS_PATH" ]; then
    echo "AI skills path not found: $AI_SKILLS_PATH"
    exit 1
fi

# Find the actual workspace directory (first subdirectory in /workspaces or current directory)
if [ -d "/workspaces" ]; then
    ACTUAL_WORKSPACE=$(find /workspaces -mindepth 1 -maxdepth 1 -type d | head -n 1)
    if [ -z "$ACTUAL_WORKSPACE" ]; then
        ACTUAL_WORKSPACE=$(pwd)
    fi
else
    ACTUAL_WORKSPACE=$(pwd)
fi

echo "Setting up AI config symlinks in: $ACTUAL_WORKSPACE"

# Symlink .clinerules if it exists
if [ -f "$AI_SKILLS_PATH/.clinerules" ]; then
    ln -sf "$AI_SKILLS_PATH/.clinerules" "$ACTUAL_WORKSPACE/.clinerules"
    echo "✓ Linked .clinerules"
fi

# Symlink .clauderc if it exists (Claude CLI config)
if [ -f "$AI_SKILLS_PATH/.clauderc" ]; then
    ln -sf "$AI_SKILLS_PATH/.clauderc" "$ACTUAL_WORKSPACE/.clauderc"
    echo "✓ Linked .clauderc"
fi

# Symlink custom prompts directory if it exists
if [ -d "$AI_SKILLS_PATH/prompts" ]; then
    ln -sf "$AI_SKILLS_PATH/prompts" "$ACTUAL_WORKSPACE/.ai-prompts"
    echo "✓ Linked prompts directory"
fi

# Symlink MCP configs if they exist
if [ -d "$AI_SKILLS_PATH/mcp-configs" ]; then
    mkdir -p "$HOME/.config"
    ln -sf "$AI_SKILLS_PATH/mcp-configs" "$HOME/.config/mcp"
    echo "✓ Linked MCP configs"
fi

echo "AI config setup complete!"
SETUP_SCRIPT

        chmod +x /usr/local/bin/setup-ai-configs
        echo "✓ Created setup-ai-configs utility"

        # Add to profile for automatic setup
        echo '[ -f /usr/local/bin/setup-ai-configs ] && /usr/local/bin/setup-ai-configs' >> /etc/bash.bashrc
    fi

    # MCP Server Configuration sync
    if [ "$SYNC_MCP_CONFIGS" = "true" ]; then
        echo "Setting up MCP configuration sync..."

        if [ -d "${TARGET_PATH}/repo/mcp-servers" ]; then
            # Create MCP config directory
            mkdir -p /root/.config/mcp
            mkdir -p /home/vscode/.config/mcp 2>/dev/null || true

            # Link MCP server configs
            if [ -f "${TARGET_PATH}/repo/mcp-servers/config.json" ]; then
                ln -sf "${TARGET_PATH}/repo/mcp-servers/config.json" /root/.config/mcp/config.json
                [ -d /home/vscode ] && ln -sf "${TARGET_PATH}/repo/mcp-servers/config.json" /home/vscode/.config/mcp/config.json || true
                echo "✓ Linked MCP server configuration"
            fi
        fi
    fi

    # Create update script for refreshing configs
    cat > /usr/local/bin/update-ai-configs <<'UPDATE_SCRIPT'
#!/bin/bash
# Update AI configuration from remote repository

AI_SKILLS_PATH="${AI_SKILLS_PATH:-/usr/local/share/ai-configs/repo}"

if [ ! -d "$AI_SKILLS_PATH/.git" ]; then
    echo "Error: Not a git repository: $AI_SKILLS_PATH"
    exit 1
fi

echo "Updating AI configurations..."
cd "$AI_SKILLS_PATH"
git pull origin "$(git branch --show-current)"
echo "✓ AI configurations updated successfully!"

# Re-run setup to update symlinks
if command -v setup-ai-configs >/dev/null 2>&1; then
    setup-ai-configs
fi
UPDATE_SCRIPT

    chmod +x /usr/local/bin/update-ai-configs
    echo "✓ Created update-ai-configs utility"

else
    echo "No configuration repository URL provided."
    echo "You can manually clone your configs to ${TARGET_PATH}"
fi

echo "=========================================="
echo "AI Agent Skills Feature installed!"
echo "=========================================="
echo ""
echo "Available commands:"
echo "  setup-ai-configs   - Create symlinks in workspace"
echo "  update-ai-configs  - Pull latest configs from repo"
echo ""
echo "Environment variables:"
echo "  AI_SKILLS_PATH=${TARGET_PATH}/repo"
echo ""
