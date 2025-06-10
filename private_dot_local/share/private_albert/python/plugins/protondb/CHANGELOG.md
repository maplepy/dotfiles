# Changelog

All notable changes to the ProtonDB Search Plugin for Albert will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Maybe in the future
- Configuration options for cache timeout
- Support for Steam Deck compatibility ratings
- Integration with Steam wishlist

## [1.0.0] - 2025-06-09

### Added
- Initial release of ProtonDB Search Plugin for Albert
- Smart search algorithm with match prioritization
  - Exact matches prioritized first
  - Games starting with search term ranked second
  - Games containing search term ranked third
  - Automatic filtering of demos, trailers, and test versions
- Comprehensive error handling and fallback logging
- Rate limiting to respect ProtonDB API limits (0.2s between requests)
- In-memory caching system with 5-minute timeout
- Support for all ProtonDB rating tiers:
  - 🥇 Platinum: Perfect - Runs flawlessly out of the box
  - 🥇 Gold: Great - Runs perfectly after tweaks
  - 🥈 Silver: Good - Runs with minor issues
  - 🥉 Bronze: Okay - Runs with significant issues
  - 💀 Borked: Broken - Does not run
  - ❓ Pending: Unknown - No reports yet
- Interactive test script for debugging (`test_search.py`)
- Automated installation script with dependency checking
- Local Steam game database (~250,000 games)
- Automatic weekly updates of Steam game database
- Multiple action options per result:
  - Open game page on ProtonDB
  - Open game page on Steam Store
  - Copy game information to clipboard
- Cross-platform compatibility (Linux focus)
- MIT License

### Technical Features
- Python 3.7+ compatibility
- Robust API error handling
- Fallback logging system for Albert compatibility
- Memory-efficient search algorithms
- Respectful API usage patterns
- Comprehensive test suite

### Documentation
- Detailed README with installation instructions
- Usage examples and troubleshooting guide
- Technical implementation details
- Contributing guidelines
- Performance specifications

---

## Release Notes

### Version 1.0.0
This is the initial stable release of the ProtonDB Search Plugin for Albert. The plugin has been thoroughly tested and includes all core functionality for searching and displaying game compatibility ratings from ProtonDB.

**Key Highlights:**
- Fast local search through 250,000+ Steam games
- Intelligent matching algorithm that prioritizes exact matches
- Comprehensive ProtonDB integration with all rating tiers
- Built-in rate limiting and caching for optimal performance
- Easy installation with automated script
- Extensive testing and debugging tools

**System Requirements:**
- Albert launcher with Python plugin support
- Python 3.7 or higher
- `requests` library
- Internet connection for API calls

**Known Issues:**
- "albert has no attribute warning" error during development (handled gracefully)
- Initial search may be slower while downloading Steam database
- API rate limiting may cause delays during rapid searches (by design)

**Future Development:**
The plugin is designed with extensibility in mind. Future versions will include additional ProtonDB features, configuration options, and enhanced user experience improvements.
