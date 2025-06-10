#!/bin/bash

# Movie Search & Stream Plugin Installation Script for Albert
# This script installs the Movie Search & Stream plugin for Albert launcher

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
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

print_bold() {
    echo -e "${BOLD}$1${NC}"
}

# Legal notice
print_legal_notice() {
    echo
    print_bold "⚠️  IMPORTANT LEGAL NOTICE ⚠️"
    echo "This plugin facilitates access to torrented content which may be copyrighted."
    echo "Users are responsible for complying with their local laws and regulations."
    echo "Only use this plugin for content you have the legal right to access."
    echo
    read -p "Do you understand and agree to use this plugin responsibly? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled by user"
        exit 0
    fi
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
check_python_dependencies() {
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
        print_success "Python requests library found"
    fi
}

# Check WebTorrent CLI
check_webtorrent() {
    print_info "Checking WebTorrent CLI..."
    
    if ! command -v webtorrent &> /dev/null; then
        print_warning "WebTorrent CLI not found"
        print_info "WebTorrent CLI is required for streaming and downloading movies"
        
        if command -v npm &> /dev/null; then
            print_info "Installing WebTorrent CLI via npm..."
            npm install -g webtorrent-cli
            
            if command -v webtorrent &> /dev/null; then
                print_success "WebTorrent CLI installed successfully"
            else
                print_error "Failed to install WebTorrent CLI"
                print_info "Please install manually: npm install -g webtorrent-cli"
                exit 1
            fi
        else
            print_error "npm not found. Please install Node.js and npm first"
            print_info "Then run: npm install -g webtorrent-cli"
            exit 1
        fi
    else
        WT_VERSION=$(webtorrent --version 2>/dev/null || echo "unknown")
        print_success "WebTorrent CLI found (version: $WT_VERSION)"
    fi
}

# Check VLC Media Player
check_vlc() {
    print_info "Checking VLC Media Player..."
    
    if ! command -v vlc &> /dev/null; then
        print_warning "VLC Media Player not found"
        print_info "VLC is required for streaming movies"
        print_info "Please install VLC:"
        echo "  Ubuntu/Debian: sudo apt install vlc"
        echo "  Fedora:        sudo dnf install vlc"
        echo "  Arch Linux:    sudo pacman -S vlc"
        echo "  macOS:         brew install --cask vlc"
        echo
        print_warning "Continuing installation without VLC (streaming will not work)"
    else
        print_success "VLC Media Player found"
    fi
}

# Check Mullvad VPN (optional)
check_mullvad() {
    print_info "Checking Mullvad VPN CLI (optional)..."
    
    if ! command -v mullvad &> /dev/null; then
        print_warning "Mullvad VPN CLI not found"
        print_info "Mullvad VPN CLI is optional but recommended for privacy"
        print_info "Download from: https://mullvad.net/download/app/"
    else
        MULLVAD_STATUS=$(mullvad status 2>/dev/null || echo "not configured")
        print_success "Mullvad VPN CLI found ($MULLVAD_STATUS)"
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
    
    print_info "Installing Movie Search & Stream plugin to: $ALBERT_PLUGINS_DIR"
    
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Copy the plugin files
    TARGET_DIR="$ALBERT_PLUGINS_DIR/movies"
    
    if [ -d "$TARGET_DIR" ]; then
        print_warning "Movie Search & Stream plugin already exists at $TARGET_DIR"
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
    
    # Copy additional files
    for file in "README.md" "requirements.txt" "test_search.py" "CHANGELOG.md" "config-template.json"; do
        if [ -f "$SCRIPT_DIR/$file" ]; then
            cp "$SCRIPT_DIR/$file" "$TARGET_DIR/"
            print_info "Copied $file"
        fi
    done
    
    # Make test script executable
    if [ -f "$TARGET_DIR/test_search.py" ]; then
        chmod +x "$TARGET_DIR/test_search.py"
    fi
    
    print_success "Movie Search & Stream plugin installed successfully!"
}

# Create sample download directory and config
create_download_directory() {
    DEFAULT_DOWNLOAD_DIR="$HOME/Downloads/Movies"
    
    if [ ! -d "$DEFAULT_DOWNLOAD_DIR" ]; then
        print_info "Creating default download directory: $DEFAULT_DOWNLOAD_DIR"
        mkdir -p "$DEFAULT_DOWNLOAD_DIR"
        print_success "Download directory created"
    else
        print_info "Download directory already exists: $DEFAULT_DOWNLOAD_DIR"
    fi
}

# Setup configuration
setup_configuration() {
    TARGET_DIR="$HOME/.local/share/albert/python/plugins/movies"
    DATA_DIR="$TARGET_DIR/data"
    CONFIG_FILE="$DATA_DIR/config.json"
    TEMPLATE_FILE="$TARGET_DIR/config-template.json"
    
    # Create data directory
    mkdir -p "$DATA_DIR"
    
    # Copy template if config doesn't exist
    if [ ! -f "$CONFIG_FILE" ] && [ -f "$TEMPLATE_FILE" ]; then
        print_info "Creating default configuration file..."
        
        # Create clean config from template (remove comments)
        cat > "$CONFIG_FILE" << 'EOF'
{
  "tmdb_api_key": "",
  "download_path": "~/Downloads/Movies",
  "search_limit": 5,
  "order_by": "rating",
  "sort_direction": "desc",
  "auto_vpn": false,
  "default_player": "auto",
  "custom_trackers": [
    "udp://open.demonii.com:1337/announce",
    "udp://tracker.openbittorrent.com:80",
    "udp://tracker.coppersurfer.tk:6969",
    "udp://glotorrents.pw:6969/announce",
    "udp://tracker.opentrackr.org:1337/announce",
    "udp://torrent.gresille.org:80/announce",
    "udp://p4p.arenabg.com:1337",
    "udp://tracker.leechers-paradise.org:6969"
  ]
}
EOF
        print_success "Configuration file created at $CONFIG_FILE"
        print_info "You can edit this file to customize plugin behavior"
    else
        print_info "Configuration file already exists"
    fi
}

# Test plugin functionality
test_plugin() {
    TARGET_DIR="$HOME/.local/share/albert/python/plugins/movies"
    
    if [ -f "$TARGET_DIR/test_search.py" ]; then
        print_info "Testing plugin functionality..."
        
        # Test dependencies
        if python3 "$TARGET_DIR/test_search.py" --test-deps &>/dev/null; then
            print_success "Plugin dependencies test passed"
        else
            print_warning "Plugin dependencies test had issues (check manually)"
        fi
    fi
}

# Main installation function
main() {
    echo
    echo "=========================================================="
    echo "  Movie Search & Stream Plugin for Albert Installer     "
    echo "=========================================================="
    echo
    
    # Show legal notice first
    print_legal_notice
    
    print_info "Starting installation..."
    
    # Check system requirements
    check_albert
    check_python_dependencies
    check_webtorrent
    check_vlc
    check_mullvad
    
    # Install the plugin
    install_plugin
    create_download_directory
    setup_configuration
    
    # Test installation
    test_plugin
    
    echo
    print_success "Installation completed!"
    echo
    print_bold "NEXT STEPS:"
    echo "  1. Restart Albert launcher"
    echo "  2. Open Albert settings (Ctrl+,)"
    echo "  3. Go to Extensions tab"
    echo "  4. Enable 'Movie Search & Stream' plugin"
    echo "  5. Configure plugin settings (click 'Configure' button)"
    echo "  6. Use 'movie <movie title>' to search"
    echo
    print_bold "CONFIGURATION:"
    echo "  • Configuration file: ~/.local/share/albert/python/plugins/movies/data/config.json"
    echo "  • Template file: ~/.local/share/albert/python/plugins/movies/config-template.json"
    echo "  • Edit config.json to customize download path, search limits, VPN settings"
    echo "  • Get TMDb API key from: https://www.themoviedb.org/settings/api (optional)"
    echo
    print_bold "EXAMPLE USAGE:"
    echo "  movie the matrix"
    echo "  movie inception"
    echo "  movie pulp fiction"
    echo "  movie avengers endgame"
    echo
    print_bold "TESTING:"
    echo "  Test the plugin: python3 ~/.local/share/albert/python/plugins/movies/test_search.py"
    echo
    print_bold "⚠️  REMEMBER:"
    echo "  • Always use VPN when torrenting"
    echo "  • Only download content you have legal rights to access"
    echo "  • Respect copyright laws and support content creators"
    echo "  • This plugin is for educational purposes only"
    echo
}

# Run the installer
main "$@"