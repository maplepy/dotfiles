# Changelog

All notable changes to the Movie Search Plugin for Albert will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Maybe in the future
- Configuration UI for plugin settings
- Support for TV shows and series search
- Integration with streaming service availability
- Poster image display in search results
- Advanced filtering options (genre, year, rating)
- Watchlist functionality
- Local favorites and rating system

## [1.0.0] - 2025-01-09

### Added
- Initial release of Movie Search Plugin for Albert
- TMDb (The Movie Database) API integration
  - Search for movies by title
  - Get detailed movie information including ratings, genres, runtime
  - Access to movie overviews and plot summaries
- Comprehensive movie information display:
  - Visual rating indicators (⭐⭐⭐⭐⭐ Excellent to ⭐ Poor)
  - Release year and runtime information
  - Genre classification
  - Movie overview/plot summary
- Multiple action options per result:
  - Open movie page on TMDb
  - Open movie page on IMDb (when available)
  - Open official movie website (when available)
  - Copy movie information to clipboard
  - Copy movie overview to clipboard
- Smart caching system with 5-minute timeout
- Rate limiting to respect TMDb API guidelines
- Comprehensive error handling and fallback logging
- Cross-platform compatibility (Linux focus)
- MIT License

### Technical Features
- Python 3.7+ compatibility
- Robust API error handling with graceful degradation
- Fallback logging system for Albert compatibility
- Memory-efficient caching system
- Respectful API usage patterns
- Comprehensive test suite with interactive testing
- Configuration file support for API key management

### Documentation
- Detailed README with installation and setup instructions
- Usage examples and troubleshooting guide
- API key setup instructions for TMDb
- Technical implementation details
- Testing and debugging tools
- Performance specifications

### Installation & Setup
- Automated installation script with dependency checking
- API key configuration support
- Sample configuration file generation
- Comprehensive installation validation

---

## Release Notes

### Version 1.0.0
This is the initial stable release of the Movie Search Plugin for Albert. The plugin provides a clean, fast interface to search for movie information using The Movie Database (TMDb) API.

**Key Highlights:**
- Fast movie search with rich information display
- Visual rating system with star indicators
- Multiple action options for each movie result
- Built-in caching for improved performance
- Comprehensive API error handling
- Easy installation with automated script
- Extensive testing and debugging tools

**System Requirements:**
- Albert launcher with Python plugin support
- Python 3.7 or higher
- `requests` library
- TMDb API key (free from https://www.themoviedb.org/settings/api)
- Internet connection for API calls

**Known Issues:**
- "albert has no attribute warning" error during development (handled gracefully)
- API key must be manually configured before first use
- Rate limiting may cause delays during rapid searches (by design)
- Some very new or very old movies may not be available in TMDb database

**Future Development:**
The plugin is designed with extensibility in mind. Future versions will include TV show support, streaming availability integration, and enhanced user experience improvements.

**Privacy & Legal:**
- This plugin uses The Movie Database (TMDb) API
- Movie data is provided by TMDb under their terms of service
- No personal data is stored beyond cached search results
- Users must comply with TMDb's API terms of use
- Plugin is not affiliated with TMDb or IMDb

**Getting Started:**
1. Install the plugin using the provided installation script
2. Get a free TMDb API key from https://www.themoviedb.org/settings/api
3. Configure the API key in the plugin
4. Enable the plugin in Albert settings
5. Use `movie <title>` to search for movies

**Example Usage:**
```
movie the matrix
movie inception
movie pulp fiction
movie marvel avengers
```

**Support:**
- Use the included test script to debug search issues
- Check the troubleshooting section in README.md
- Ensure API key is properly configured
- Verify internet connection for API access