# ProtonDB Search Plugin for Albert

Search for game compatibility ratings on ProtonDB directly from Albert launcher.

![ProtonDB Plugin Demo](https://img.shields.io/badge/Albert-Plugin-blue?style=flat-square)
![Python](https://img.shields.io/badge/Python-3.7+-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

## Overview

The ProtonDB Search plugin allows you to quickly search for game compatibility ratings on [ProtonDB](https://www.protondb.com/) directly from Albert launcher. ProtonDB is a community-driven database that tracks how well Windows games run on Linux using Steam's Proton compatibility layer.

## Features

- 🔍 **Fast Search**: Search through 250,000+ Steam games using local database
- 🎮 **Compatibility Ratings**: Get ProtonDB ratings (Platinum, Gold, Silver, Bronze, Borked)
- 🚀 **Quick Actions**: Open games on ProtonDB, Steam, or copy game info
- 📊 **Smart Matching**: Prioritizes exact matches and filters out demos/trailers
- 💾 **Caching**: Caches results to reduce API calls
- 🔄 **Auto-Update**: Automatically updates Steam game database weekly

## Installation

### Method 1: Using the Install Script (Recommended)

1. Clone or download this plugin to your Albert plugins directory
2. Run the installation script:
   ```bash
   cd albert-plugins/python/plugins/protondb
   chmod +x install.sh
   ./install.sh
   ```

### Method 2: Manual Installation

1. Copy the plugin files to your Albert Python plugins directory:
   ```bash
   # Find your Albert data directory
   # Usually ~/.local/share/albert/python/plugins/
   
   mkdir -p ~/.local/share/albert/python/plugins/protondb
   cp -r * ~/.local/share/albert/python/plugins/protondb/
   ```

2. Install Python dependencies:
   ```bash
   pip install requests
   ```

3. Restart Albert and enable the plugin:
   - Open Albert settings (Ctrl+,)
   - Go to Extensions tab
   - Enable "ProtonDB Search" plugin

## Usage

### Basic Search
```
proton cyberpunk 2077
proton the witcher 3
proton doom eternal
```

### Search Results
Each result shows:
- 🥇 **Platinum**: Perfect - Runs flawlessly out of the box
- 🥇 **Gold**: Great - Runs perfectly after tweaks
- 🥈 **Silver**: Good - Runs with minor issues
- 🥉 **Bronze**: Okay - Runs with significant issues
- 💀 **Borked**: Broken - Does not run
- ❓ **Pending**: Unknown - No reports yet

### Available Actions
- **Open on ProtonDB**: View detailed compatibility reports
- **Open on Steam**: Go to the game's Steam store page
- **Copy game info**: Copy game name and compatibility rating

## How It Works

1. **Steam Database**: Downloads and maintains a local copy of Steam's game database
2. **Smart Search**: Searches using an intelligent algorithm that prioritizes:
   - Exact matches first
   - Games that start with your search term
   - Games that contain your search term
   - Filters out demos, trailers, and test versions
3. **ProtonDB API**: Queries ProtonDB for compatibility ratings
4. **Caching**: Caches results for 5 minutes to improve performance
5. **Rate Limiting**: Includes delays between API calls to be respectful

## Troubleshooting

### "albert has no attribute warning" Error

This is a common issue that occurs because Albert's logging functions are dynamically attached at runtime. The plugin already handles this with fallback logging functions, so you can safely ignore this error during development.

### No Games Found

- Make sure you're using the correct game name (try "the witcher 3" instead of "witcher")
- The plugin downloads the Steam database on first use - this may take a moment
- Try more specific search terms (e.g., "cyberpunk 2077" instead of "cyberpunk")

### API Rate Limiting

The plugin includes built-in rate limiting to avoid overwhelming ProtonDB's servers. If you see slower responses, this is normal and expected behavior.

## Testing

A test script is included to help debug search functionality:

```bash
# Test a specific game
python3 test_search.py "cyberpunk 2077"

# Interactive testing
python3 test_search.py

# Run predefined tests
python3 test_search.py
# Then choose option 2
```

## Technical Details

### Dependencies
- Python 3.7+
- `requests` library
- Albert launcher with Python plugin support

### Data Storage
- Steam game database: `~/.local/share/albert/python/plugins/protondb/data/steamapi.json`
- Cache: In-memory (5-minute timeout)
- Updates: Steam database refreshes weekly

### API Endpoints
- Steam API: `https://api.steampowered.com/ISteamApps/GetAppList/v2/`
- ProtonDB API: `https://www.protondb.com/api/v1/reports/summaries/{appid}.json`

### Performance
- Local Steam database: ~250,000 games searchable in milliseconds
- ProtonDB API calls: Rate-limited to 0.2 seconds between requests
- Memory usage: ~50MB for Steam database, minimal for cache

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using the test script
5. Submit a pull request

### Development Tips

- Use the test script to verify search functionality
- The plugin includes fallback logging for development
- Check the Albert stub file for API reference
- Follow Albert's plugin development guidelines

## License

MIT License. See LICENSE file for details.

## Credits

- Inspired by the [Ulauncher ProtonDB plugin](https://github.com/NoXPhasma/ulauncher-protondb-search)
- Uses [ProtonDB](https://www.protondb.com/) API
- Uses [Steam Web API](https://steamcommunity.com/dev)

## Documentation

For detailed technical documentation, architecture diagrams, and development guides, see [DOCUMENTATION.md](DOCUMENTATION.md).

For version history and changes, see [CHANGELOG.md](CHANGELOG.md).

---

**Note**: This plugin is not affiliated with ProtonDB or Valve Corporation. ProtonDB is a community project that tracks game compatibility.