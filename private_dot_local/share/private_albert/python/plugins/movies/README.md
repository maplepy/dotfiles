# Movie Search & Stream Plugin for Albert

Search for movies and stream/download them via torrents directly from Albert launcher.

![Movie Plugin Demo](https://img.shields.io/badge/Albert-Plugin-blue?style=flat-square)
![Python](https://img.shields.io/badge/Python-3.7+-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

⚠️ **IMPORTANT LEGAL NOTICE** ⚠️
This plugin facilitates access to torrented content which may be copyrighted. Users are responsible for complying with their local laws and regulations. Only use this plugin for content you have the legal right to access.

## Overview

The Movie Search & Stream plugin allows you to search for movies using the YTS API and stream or download them using WebTorrent technology directly from Albert launcher. This plugin is inspired by the Ulauncher movie extension but adapted for Albert's architecture.

## Features

- 🎬 **Fast Movie Search**: Search through YTS database of movies
- 🎥 **Stream Movies**: Stream movies directly using WebTorrent + VLC
- 📥 **Download Movies**: Download movies to your specified directory
- 🎯 **Quality Selection**: Choose from different video qualities (720p, 1080p, etc.)
- ⭐ **Movie Ratings**: Visual rating indicators and movie information
- 🛡️ **VPN Integration**: Auto-connect to Mullvad VPN (optional)
- ⚙️ **Albert Settings**: Configure all options directly in Albert's settings
- 💾 **Smart Caching**: Caches results to improve performance

## Installation

### Prerequisites

1. **WebTorrent CLI**: Required for streaming and downloading
   ```bash
   npm install -g webtorrent-cli
   ```

2. **VLC Media Player**: Required for streaming movies
   ```bash
   # Ubuntu/Debian
   sudo apt install vlc
   
   # Fedora
   sudo dnf install vlc
   
   # Arch Linux
   sudo pacman -S vlc
   ```

3. **Python Dependencies**:
   ```bash
   pip install requests
   ```

4. **VPN (Recommended)**: Mullvad VPN with CLI for legal protection
   ```bash
   # Download from https://mullvad.net/download/app/
   # Or install CLI: https://mullvad.net/help/cli-guide/
   ```

### Method 1: Using the Install Script (Recommended)

1. Clone or download this plugin to your Albert plugins directory
2. Run the installation script:
   ```bash
   cd albert-plugins/python/plugins/movies
   chmod +x install.sh
   ./install.sh
   ```

### Method 2: Manual Installation

1. Copy the plugin files to your Albert Python plugins directory:
   ```bash
   mkdir -p ~/.local/share/albert/python/plugins/movies
   cp -r * ~/.local/share/albert/python/plugins/movies/
   ```

2. Install dependencies:
   ```bash
   pip install requests
   npm install -g webtorrent-cli
   ```

3. Restart Albert and enable the plugin:
   - Open Albert settings (Ctrl+,)
   - Go to Extensions tab
   - Enable "Movie Search & Stream" plugin

## Configuration

The plugin uses a configuration file located at:
`~/.local/share/albert/python/plugins/movies/data/config.json`

### Initial Setup

1. Enable the plugin in Albert settings
2. Run a search (e.g., `movie test`) to create the default config file
3. Edit the configuration file to customize settings

### Configuration File Format

```json
{
  "tmdb_api_key": "",
  "download_path": "~/Downloads/Movies",
  "search_limit": 5,
  "order_by": "rating",
  "sort_direction": "desc",
  "auto_vpn": false,
  "custom_trackers": [
    "udp://open.demonii.com:1337/announce",
    "udp://tracker.openbittorrent.com:80"
  ]
}
```

### Available Settings

- **tmdb_api_key**: Optional - TMDb API key for enhanced movie information
- **download_path**: Where movies will be downloaded (default: ~/Downloads/Movies)
- **search_limit**: Maximum number of results to show (1-20)
- **order_by**: Sort by "rating", "year", "title", or "date_added"
- **sort_direction**: "desc" (descending) or "asc" (ascending)
- **auto_vpn**: true/false - automatically connect Mullvad VPN before torrenting
- **custom_trackers**: Array of additional tracker URLs for better connectivity

### Quick Configuration Access

When you search without a term (`movie`), the plugin will show a "Open Configuration File" action that opens the config file directly.

## Usage

### Basic Search
```
movie the matrix
movie inception
movie pulp fiction
movie avengers endgame
```

### Search Results Display
```
⭐⭐⭐⭐⭐ The Matrix (1999)
⭐ 8.7/10 • ⏱️ 2h 16m • 🎭 Action, Science Fiction

⭐⭐⭐⭐ Inception (2010)  
⭐ 8.4/10 • ⏱️ 2h 28m • 🎭 Action, Science Fiction, Mystery
```

### Available Actions for Each Movie

#### Streaming Options
- **🎥 Stream 1080p (1.2GB)**: Stream movie in 1080p quality
- **🎥 Stream 720p (800MB)**: Stream movie in 720p quality

#### Download Options
- **📥 Download 1080p (1.2GB)**: Download movie in 1080p quality
- **📥 Download 720p (800MB)**: Download movie in 720p quality

#### Information Options
- **🌐 Open on IMDb**: View movie on IMDb
- **🌐 Open on YTS**: View movie on YTS website
- **📋 Copy Movie Info**: Copy movie details to clipboard

## How It Works

1. **Search Phase**: 
   - Queries YTS API for movies matching your search term
   - Displays results with ratings, runtime, and genres

2. **Selection Phase**:
   - Choose quality and action (stream or download)
   - Plugin builds magnet URI with tracker information

3. **Streaming**:
   - Uses WebTorrent CLI to stream the torrent
   - Automatically opens VLC for playback
   - Downloads to specified directory in background

4. **Downloading**:
   - Uses WebTorrent CLI to download the complete file
   - Saves to your configured download directory

## VPN Integration

For legal protection and privacy, the plugin supports auto-connecting to Mullvad VPN:

1. Install Mullvad VPN and CLI
2. Enable "Auto-connect VPN" in plugin settings
3. Plugin will automatically connect before any torrent activity

## Legal Considerations

⚠️ **IMPORTANT**: This plugin is for educational purposes and should only be used for:

- Content you already own
- Content in the public domain
- Content you have legal rights to access
- Educational and research purposes where permitted by law

**Users are solely responsible for:**
- Complying with local copyright laws
- Understanding their legal rights and obligations
- Using appropriate VPN protection where required
- Respecting content creators' rights

## Troubleshooting

### "No movies found" Error
- Check your spelling - movie titles should be reasonably accurate
- Try different search terms (e.g., "matrix" instead of "the matrix")
- Ensure internet connection is working

### Streaming/Download Issues
- Verify WebTorrent CLI is installed: `webtorrent --version`
- Verify VLC is installed: `vlc --version`
- Check if VPN is required in your region
- Ensure download directory is writable

### VPN Connection Issues
- Verify Mullvad CLI is installed: `mullvad status`
- Ensure Mullvad account is active
- Check if you're already connected to a VPN

### Plugin Configuration Issues
- Check Albert's plugin settings are properly configured
- Verify download path exists and is writable
- Restart Albert after configuration changes

## Testing

A test script is included to help debug functionality:

```bash
# Test YTS API connectivity
python3 test_search.py --test-api

# Test specific movie search
python3 test_search.py "the matrix"

# Interactive testing
python3 test_search.py
```

## Technical Details

### Dependencies
- Python 3.7+
- `requests` library
- Albert launcher with Python plugin support
- WebTorrent CLI
- VLC Media Player
- Mullvad VPN CLI (optional)

### API Endpoints
- YTS API: `https://yts.mx/api/v2/list_movies.json`
- TMDb API: `https://api.themoviedb.org/3/` (optional)

### File Structure
```
~/.local/share/albert/python/plugins/movies/
├── __init__.py           # Main plugin code
├── README.md            # This documentation
├── install.sh           # Installation script
├── test_search.py       # Testing script
├── requirements.txt     # Python dependencies
└── CHANGELOG.md         # Version history
```

### Performance
- Search results: Usually under 2 seconds
- Streaming: Starts within 10-30 seconds depending on seeds
- Download: Varies based on file size and internet speed
- Memory usage: Minimal for plugin, varies for WebTorrent

## Security & Privacy

### Recommended Practices
- Always use VPN when accessing torrents
- Regularly update WebTorrent CLI and VLC
- Use reputable VPN providers
- Understand your local laws regarding torrenting

### Data Handling
- Search queries are sent to YTS servers
- No personal data is stored beyond cached search results
- Magnet URIs and torrent hashes are processed locally
- Plugin respects YTS API rate limits

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using the test script
5. Submit a pull request

### Development Guidelines
- Follow Albert plugin development standards
- Test all torrent functionality with legal content
- Ensure VPN integration works properly
- Document any new configuration options

## License

MIT License. See LICENSE file for details.

## Credits

- Inspired by [Ulauncher Movie Extension](https://github.com/Gwilym-Rutherford/ulauncher-movie-extension)
- Uses [YTS API](https://yts.mx/api) for movie data
- Built for [Albert Launcher](https://albertlauncher.github.io/)
- WebTorrent technology for streaming

## Disclaimer

This plugin is not affiliated with YTS, Albert, WebTorrent, or any movie studios. This software is provided for educational purposes only. The developers do not condone or encourage piracy or copyright infringement. Users are responsible for ensuring their use complies with applicable laws and regulations.

**Use at your own risk and responsibility.**

---

**Note**: Always respect copyright laws, support content creators, and use legal streaming services when available. This plugin should only be used for content you have legal rights to access.