#!/bin/bash
set -e

# Test script for AI Agent Skills feature
echo "Running AI Agent Skills feature tests..."

# Test 1: Check if environment variables are set
echo "Test 1: Checking environment variables..."
if [ -n "$AI_SKILLS_PATH" ]; then
    echo "✓ AI_SKILLS_PATH is set: $AI_SKILLS_PATH"
else
    echo "⚠ AI_SKILLS_PATH is not set (expected if no config repo was provided)"
fi

# Test 2: Check if utility scripts are installed
echo "Test 2: Checking utility scripts..."
if command -v setup-ai-configs >/dev/null 2>&1; then
    echo "✓ setup-ai-configs command is available"
else
    echo "✗ setup-ai-configs command not found"
    exit 1
fi

if command -v update-ai-configs >/dev/null 2>&1; then
    echo "✓ update-ai-configs command is available"
else
    echo "✗ update-ai-configs command not found"
    exit 1
fi

# Test 3: Check if target directory exists
TARGET_PATH="${TARGETPATH:-/usr/local/share/ai-configs}"
echo "Test 3: Checking target directory..."
if [ -d "$TARGET_PATH" ]; then
    echo "✓ Target directory exists: $TARGET_PATH"
else
    echo "✗ Target directory not found: $TARGET_PATH"
    exit 1
fi

# Test 4: Check if git is installed
echo "Test 4: Checking git installation..."
if command -v git >/dev/null 2>&1; then
    echo "✓ Git is installed: $(git --version)"
else
    echo "✗ Git is not installed"
    exit 1
fi

# Test 5: If config repo was cloned, verify it
if [ -d "$AI_SKILLS_PATH/.git" ]; then
    echo "Test 5: Verifying cloned repository..."
    cd "$AI_SKILLS_PATH"
    if git status >/dev/null 2>&1; then
        echo "✓ Config repository is valid"
        echo "  Repository info:"
        git remote -v | head -n 1
    else
        echo "✗ Config repository is corrupted"
        exit 1
    fi
else
    echo "Test 5: Skipping repository verification (no repo cloned)"
fi

echo ""
echo "=========================================="
echo "All tests passed! ✓"
echo "=========================================="
