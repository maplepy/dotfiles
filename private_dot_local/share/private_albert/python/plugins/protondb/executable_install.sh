#!/bin/bash

# ProtonDB Plugin Installation Script for Albert
# This script installs the ProtonDB search plugin for Albert launcher

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Albert is installed
check_albert() {
    if ! command -v albert &> /dev/null; then
        print_warning "Albert launcher not found in PATH"
        print_info "Please make sure Albert is installed before using this plugin"
    else
        print_success "Albert launcher found"
    fi
}

# Check Python dependencies
check_dependencies() {
    print_info "Checking Python dependencies..."
    
    if ! python3 -c "import requests" &> /dev/null; then
        print_warning "Python 'requests' library not found"
        print_info "Installing requests library..."
        
        if command -v pip3 &> /dev/null; then
            pip3 install requests
        elif command -v pip &> /dev/null; then
            pip install requests
        else
            print_error "pip not found. Please install 'requests' manually: pip install requests"
            exit 1
        fi
    else
        print_success "Python dependencies satisfied"
    fi
}

# Install the plugin
install_plugin() {
    # Determine Albert plugins directory
    ALBERT_PLUGINS_DIR=""
    
    # Check common locations
    if [ -d "$HOME/.local/share/albert/python/plugins" ]; then
        ALBERT_PLUGINS_DIR="$HOME/.local/share/albert/python/plugins"
    elif [ -d "$HOME/.config/albert/plugins" ]; then
        ALBERT_PLUGINS_DIR="$HOME/.config/albert/plugins"
    else
        # Create the directory if it doesn't exist
        ALBERT_PLUGINS_DIR="$HOME/.local/share/albert/python/plugins"
        print_info "Creating Albert plugins directory: $ALBERT_PLUGINS_DIR"
        mkdir -p "$ALBERT_PLUGINS_DIR"
    fi
    
    print_info "Installing ProtonDB plugin to: $ALBERT_PLUGINS_DIR"
    
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Copy the plugin files
    TARGET_DIR="$ALBERT_PLUGINS_DIR/protondb"
    
    if [ -d "$TARGET_DIR" ]; then
        print_warning "ProtonDB plugin already exists at $TARGET_DIR"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
        rm -rf "$TARGET_DIR"
    fi
    
    # Create target directory and copy files
    mkdir -p "$TARGET_DIR"
    
    # Copy main plugin file
    if [ -f "$SCRIPT_DIR/__init__.py" ]; then
        cp "$SCRIPT_DIR/__init__.py" "$TARGET_DIR/"
        print_success "Copied plugin code"
    else
        print_error "Plugin code not found at $SCRIPT_DIR/__init__.py"
        exit 1
    fi
    
    # Copy requirements file
    if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
        cp "$SCRIPT_DIR/requirements.txt" "$TARGET_DIR/"
    fi
    
    # Copy README
    if [ -f "$SCRIPT_DIR/README.md" ]; then
        cp "$SCRIPT_DIR/README.md" "$TARGET_DIR/"
    fi
    
    print_success "ProtonDB plugin installed successfully!"
}

# Main installation function
main() {
    echo
    echo "=========================================="
    echo "  ProtonDB Plugin for Albert Installer  "
    echo "=========================================="
    echo
    
    print_info "Starting installation..."
    
    # Check system requirements
    check_albert
    check_dependencies
    
    # Install the plugin
    install_plugin
    
    echo
    print_success "Installation completed!"
    echo
    print_info "Next steps:"
    echo "  1. Restart Albert launcher"
    echo "  2. Open Albert settings (Ctrl+,)"
    echo "  3. Go to Extensions tab"
    echo "  4. Enable 'ProtonDB Search' plugin"
    echo "  5. Use 'proton <game name>' to search"
    echo
    print_info "Example usage:"
    echo "  proton cyberpunk"
    echo "  proton witcher 3"
    echo "  proton doom eternal"
    echo
    print_warning "Note: First search may take a moment to download Steam game database"
    echo
}

# Run the installer
main "$@"