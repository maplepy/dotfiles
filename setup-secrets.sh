#!/bin/bash

# Secure secrets setup for chezmoi
# This script sets up environment variables for API keys
# Run this script before using chezmoi on a new machine

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up secrets for chezmoi...${NC}"

# Check if running on authorized machine
HOSTNAME=$(hostname)
AUTHORIZED_MACHINES=("desktop-main" "laptop-personal" "workstation-home" "canary")

is_authorized=false
for machine in "${AUTHORIZED_MACHINES[@]}"; do
    if [[ "$HOSTNAME" == "$machine" ]]; then
        is_authorized=true
        break
    fi
done

if [[ "$is_authorized" == false ]]; then
    echo -e "${RED}Warning: Machine '$HOSTNAME' is not in the authorized machines list${NC}"
    echo -e "${YELLOW}Add '$HOSTNAME' to authorized_machines in chezmoi.toml if this machine should have access${NC}"
    exit 1
fi

# Create secure environment file
ENV_FILE="$HOME/.config/chezmoi/secrets.env"
mkdir -p "$(dirname "$ENV_FILE")"

# Check if secrets file already exists
if [[ -f "$ENV_FILE" ]]; then
    echo -e "${YELLOW}Secrets file already exists at $ENV_FILE${NC}"
    read -p "Do you want to update it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting without changes"
        exit 0
    fi
fi

# Prompt for API key
echo "Please enter your GitHub Personal Access Token for fish-ai:"
read -s -p "Token: " GITHUB_TOKEN
echo

# Validate token format
if [[ ! "$GITHUB_TOKEN" =~ ^ghp_[a-zA-Z0-9]{36}$ ]]; then
    echo -e "${RED}Warning: Token doesn't match expected GitHub PAT format${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting without saving"
        exit 1
    fi
fi

# Write to secrets file
cat > "$ENV_FILE" << EOF
# Chezmoi secrets - DO NOT COMMIT TO GIT
# This file contains sensitive API keys and tokens
# Generated on $(date)
# Machine: $HOSTNAME

export FISH_AI_GITHUB_TOKEN="$GITHUB_TOKEN"

# Add other API keys here as needed:
# export OPENAI_API_KEY="your-openai-key"
# export ANTHROPIC_API_KEY="your-anthropic-key"
EOF

# Set secure permissions
chmod 600 "$ENV_FILE"

echo -e "${GREEN}Secrets file created at $ENV_FILE${NC}"
echo -e "${GREEN}Permissions set to 600 (owner read/write only)${NC}"

# Add to shell profile if not already there
SHELL_PROFILE=""
if [[ -f "$HOME/.bashrc" ]]; then
    SHELL_PROFILE="$HOME/.bashrc"
elif [[ -f "$HOME/.zshrc" ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [[ -f "$HOME/.config/fish/config.fish" ]]; then
    SHELL_PROFILE="$HOME/.config/fish/config.fish"
fi

if [[ -n "$SHELL_PROFILE" ]]; then
    SOURCE_LINE="source \"$ENV_FILE\""
    if [[ "$SHELL_PROFILE" == *"fish"* ]]; then
        SOURCE_LINE="source \"$ENV_FILE\""
    fi
    
    if ! grep -q "$ENV_FILE" "$SHELL_PROFILE" 2>/dev/null; then
        echo
        echo -e "${YELLOW}To automatically load secrets in new shell sessions:${NC}"
        echo "Add this line to $SHELL_PROFILE:"
        echo "  $SOURCE_LINE"
        echo
        read -p "Add it automatically? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> "$SHELL_PROFILE"
            echo "# Load chezmoi secrets" >> "$SHELL_PROFILE"
            echo "$SOURCE_LINE" >> "$SHELL_PROFILE"
            echo -e "${GREEN}Added to $SHELL_PROFILE${NC}"
        fi
    fi
fi

# Source the file for current session
source "$ENV_FILE"

echo
echo -e "${GREEN}Setup complete!${NC}"
echo "To use chezmoi with these secrets:"
echo "1. Source the secrets file: source $ENV_FILE"
echo "2. Run chezmoi commands normally"
echo
echo -e "${YELLOW}Security notes:${NC}"
echo "- The secrets file is ignored by git (.chezmoiignore)"
echo "- File permissions are set to 600 (owner only)"
echo "- Never commit secrets.env to version control"
echo "- Run this script on each authorized machine"