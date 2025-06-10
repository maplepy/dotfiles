"""
Movie Search Plugin for Albert

Search for movies and stream/download them using torrents.
Usage: movie <movie title>

WARNING: This plugin facilitates access to torrented content which may be copyrighted.
Users are responsible for complying with their local laws and regulations.
Only use this plugin for content you have the legal right to access.
"""

# Mandatory metadata
md_iid = "3.0"
md_version = "2.0"
md_name = "Movie Search & Stream"
md_description = "Search movies and stream/download via torrents"

# Optional metadata
md_license = "MIT"
md_url = "https://github.com/maplepy/albert-plugins"
md_authors = ["maplepy"]
md_bin_dependencies = ["webtorrent"]
md_lib_dependencies = ["requests"]

import albert
import requests
import json
import time
import os
import subprocess
import urllib.parse
import shutil
from urllib.parse import quote_plus

# Fallback logging functions for when albert logging is not available
def safe_warning(message):
    """Safely log warning message with fallback"""
    try:
        albert.warning(message)
    except AttributeError:
        print(f"WARNING: {message}")

def safe_debug(message):
    """Safely log debug message with fallback"""
    try:
        albert.debug(message)
    except AttributeError:
        print(f"DEBUG: {message}")

def safe_info(message):
    """Safely log info message with fallback"""
    try:
        albert.info(message)
    except AttributeError:
        print(f"INFO: {message}")

def safe_critical(message):
    """Safely log critical message with fallback"""
    try:
        albert.critical(message)
    except AttributeError:
        print(f"CRITICAL: {message}")

class Plugin(albert.PluginInstance, albert.TriggerQueryHandler):

    def __init__(self):
        albert.PluginInstance.__init__(self)
        albert.TriggerQueryHandler.__init__(self)

        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Albert Movie Search Plugin/2.0',
            'Accept': 'application/json'
        })

        # Cache for search results
        self.search_cache = {}
        self.cache_timeout = 300  # 5 minutes

        # YTS API configuration (for torrents)
        self.yts_api_base = "https://yts.mx/api/v2"
        
        # TMDb API configuration (for movie info)
        self.tmdb_base_url = "https://api.themoviedb.org/3"
        
        # Default trackers for magnet links
        self.default_trackers = [
            "udp://open.demonii.com:1337/announce",
            "udp://tracker.openbittorrent.com:80",
            "udp://tracker.coppersurfer.tk:6969",
            "udp://glotorrents.pw:6969/announce",
            "udp://tracker.opentrackr.org:1337/announce",
            "udp://torrent.gresille.org:80/announce",
            "udp://p4p.arenabg.com:1337",
            "udp://tracker.leechers-paradise.org:6969"
        ]

        # Rating icons
        self.rating_icons = {
            'excellent': '⭐⭐⭐⭐⭐',  # 8.5+
            'great': '⭐⭐⭐⭐',       # 7.0-8.4
            'good': '⭐⭐⭐',         # 6.0-6.9
            'average': '⭐⭐',        # 4.0-5.9
            'poor': '⭐',            # <4.0
            'unrated': '❓'          # No rating
        }

        # Initialize configuration attributes with defaults
        self.tmdb_api_key = ""
        self.download_path = os.path.expanduser("~/Downloads/Movies")
        self.search_limit = 5
        self.order_by = "rating"
        self.sort_direction = "desc"
        self.auto_vpn = False
        self.default_player = "auto"
        self.trackers = self.default_trackers
        
        # Detect available players
        self.available_players = self._detect_available_players()
        self.system_default_player = self._get_system_default_player()

        # Load configuration from file
        self.readConfig()

    def readConfig(self):
        """Read configuration from config file"""
        # Set defaults first
        self.tmdb_api_key = ""
        self.download_path = os.path.expanduser("~/Downloads/Movies")
        self.search_limit = 5
        self.order_by = "rating"
        self.sort_direction = "desc"
        self.auto_vpn = False
        self.default_player = "auto"
        self.trackers = self.default_trackers
        
        try:
            # Try to read from config file
            config_file = os.path.join(str(self.dataLocation()), 'config.json')
            if os.path.exists(config_file):
                with open(config_file, 'r') as f:
                    config = json.load(f)
                    
                self.tmdb_api_key = config.get("tmdb_api_key", "")
                self.download_path = config.get("download_path", os.path.expanduser("~/Downloads/Movies"))
                self.search_limit = int(config.get("search_limit", 5))
                self.order_by = config.get("order_by", "rating")
                self.sort_direction = config.get("sort_direction", "desc")
                self.auto_vpn = config.get("auto_vpn", False)
                self.default_player = config.get("default_player", "auto")
                
                custom_trackers = config.get("custom_trackers", [])
                if custom_trackers:
                    self.trackers = custom_trackers
                
                safe_debug(f"Configuration loaded from {config_file}")
            else:
                # Create default config file
                self._create_default_config(config_file)
                safe_debug("Created default configuration file")
                
        except Exception as e:
            safe_warning(f"Failed to read config: {e}")

    def defaultTrigger(self):
        return "movie "

    def synopsis(self, query):
        return "Movie Search: movie <movie title>"

    def supportsFuzzyMatching(self):
        return False

    def _create_default_config(self, config_file):
        """Create default configuration file"""
        try:
            os.makedirs(os.path.dirname(config_file), exist_ok=True)
            
            default_config = {
                "tmdb_api_key": "",
                "download_path": os.path.expanduser("~/Downloads/Movies"),
                "search_limit": 5,
                "order_by": "rating",
                "sort_direction": "desc",
                "auto_vpn": False,
                "default_player": "auto",
                "custom_trackers": self.default_trackers
            }
            
            with open(config_file, 'w') as f:
                json.dump(default_config, f, indent=2)
                
        except Exception as e:
            safe_warning(f"Failed to create default config: {e}")

    def _detect_available_players(self):
        """Detect which media players are available on the system"""
        players = {
            'vlc': 'vlc',
            'mpv': 'mpv',
            'mplayer': 'mplayer',
            'smplayer': 'smplayer',
            'kodi': 'kodi'
        }
        
        available = []
        for name, command in players.items():
            if shutil.which(command):
                available.append(name)
                safe_debug(f"Found player: {name}")
        
        return available

    def _get_system_default_player(self):
        """Get system default media player for video files"""
        try:
            # Try to get system default for video files (Linux)
            result = subprocess.run(['xdg-mime', 'query', 'default', 'video/mp4'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                desktop_file = result.stdout.strip()
                player = self._map_desktop_to_player(desktop_file)
                if player:
                    safe_debug(f"System default player: {player}")
                    return player
        except (subprocess.TimeoutExpired, FileNotFoundError, Exception) as e:
            safe_debug(f"Could not detect system default player: {e}")
        
        return None

    def _map_desktop_to_player(self, desktop_file):
        """Map .desktop file to player name"""
        player_mappings = {
            'vlc.desktop': 'vlc',
            'org.videolan.VLC.desktop': 'vlc',
            'mpv.desktop': 'mpv',
            'io.mpv.Mpv.desktop': 'mpv',
            'mplayer.desktop': 'mplayer',
            'smplayer.desktop': 'smplayer',
            'kodi.desktop': 'kodi',
            'org.xbmc.kodi.desktop': 'kodi'
        }
        
        return player_mappings.get(desktop_file.lower())

    def _get_effective_player(self):
        """Determine which player to actually use"""
        if self.default_player == "auto":
            # Auto-detect: prefer VLC > MPV > others > system default
            preferred_order = ['vlc', 'mpv', 'kodi', 'mplayer', 'smplayer']
            for player in preferred_order:
                if player in self.available_players:
                    return player
            
            # Fall back to system default if available
            if self.system_default_player and self.system_default_player in self.available_players:
                return self.system_default_player
                
            # Last resort: let WebTorrent decide
            return "webtorrent_auto"
            
        elif self.default_player == "system":
            if self.system_default_player and self.system_default_player in self.available_players:
                return self.system_default_player
            else:
                # Fall back to auto if system default not available
                return self._get_effective_player_auto()
                
        elif self.default_player in self.available_players:
            # User specified a player and it's available
            return self.default_player
            
        else:
            # User specified a player but it's not available, fall back to auto
            safe_warning(f"Configured player '{self.default_player}' not available, using auto-detection")
            return self._get_effective_player_auto()

    def _get_effective_player_auto(self):
        """Auto-detection logic separated for reuse"""
        preferred_order = ['vlc', 'mpv', 'kodi', 'mplayer', 'smplayer']
        for player in preferred_order:
            if player in self.available_players:
                return player
        return "webtorrent_auto"

    def _build_stream_command(self, magnet_uri):
        """Build WebTorrent command with appropriate player"""
        player = self._get_effective_player()
        
        base_cmd = [
            "webtorrent", 
            magnet_uri,
            "--quiet",
            "--out", self.download_path
        ]
        
        # Add player-specific flag
        if player == "vlc":
            base_cmd.append("--vlc")
        elif player == "mpv":
            base_cmd.append("--mpv")
        elif player == "mplayer":
            base_cmd.append("--mplayer")
        elif player == "smplayer":
            base_cmd.append("--smplayer")
        elif player == "kodi":
            base_cmd.append("--xbmc")
        else:
            # webtorrent_auto or unknown - let WebTorrent choose
            base_cmd.append("--player")
        
        return base_cmd

    def initialize(self):
        """Initialize plugin and read configuration"""
        # Configuration is already loaded in __init__
        pass

    def handleTriggerQuery(self, query):
        search_term = query.string.strip()

        if not search_term:
            config_file = os.path.join(str(self.dataLocation()), 'config.json')
            
            # Show player info
            effective_player = self._get_effective_player()
            player_info = f"Player: {effective_player}"
            if self.available_players:
                player_info += f" (Available: {', '.join(self.available_players)})"
            else:
                player_info += " (No players detected!)"
            
            query.add(albert.StandardItem(
                id="movie_help",
                text="Movie Search & Stream",
                subtext=f"Enter a movie title to search for torrents • {player_info}",
                iconUrls=["xdg:video-x-generic"],
                actions=[
                    albert.Action(
                        "open_config",
                        "Open Configuration File",
                        lambda: albert.openUrl(f"file://{config_file}")
                    )
                ]
            ))
            return

        if len(search_term) < 2:
            query.add(albert.StandardItem(
                id="movie_short",
                text="Search term too short",
                subtext="Please enter at least 2 characters",
                iconUrls=["dialog-warning"],
                actions=[]
            ))
            return

        # Check cache first
        cache_key = search_term.lower()
        cached_result = self._get_cached_result(cache_key)

        if cached_result:
            self._add_results_to_query(query, cached_result, search_term)
            return

        try:
            # Auto-connect VPN if enabled
            if self.auto_vpn:
                self._connect_vpn()

            # Search for movies
            movies = self._search_movies(search_term)

            if movies:
                # Cache results
                self.search_cache[cache_key] = {
                    'data': movies,
                    'timestamp': time.time()
                }
                self._add_results_to_query(query, movies, search_term)
            else:
                query.add(albert.StandardItem(
                    id="movie_no_results",
                    text="No movies found",
                    subtext=f"No movies found matching '{search_term}'",
                    iconUrls=["dialog-information"],
                    actions=[
                        albert.Action(
                            "search_web",
                            "Search on YTS website",
                            lambda: albert.openUrl(f"https://yts.mx/browse-movies/{quote_plus(search_term)}")
                        )
                    ]
                ))

        except Exception as e:
            safe_warning(f"Movie search failed: {str(e)}")
            query.add(albert.StandardItem(
                id="movie_error",
                text="Search failed",
                subtext=f"Error: {str(e)[:50]}...",
                iconUrls=["dialog-error"],
                actions=[
                    albert.Action(
                        "search_web",
                        "Open YTS website",
                        lambda: albert.openUrl("https://yts.mx")
                    )
                ]
            ))

    def _connect_vpn(self):
        """Connect to VPN using mullvad CLI"""
        try:
            safe_info("Connecting to VPN...")
            subprocess.run(["mullvad", "connect", "--wait"], 
                         check=False, capture_output=True, timeout=30)
        except Exception as e:
            safe_warning(f"Failed to connect VPN: {e}")

    def _search_movies(self, query):
        """Search for movies using YTS API"""
        try:
            url = f"{self.yts_api_base}/list_movies.json"
            params = {
                'query_term': query,
                'limit': self.search_limit,
                'order_by': self.order_by,
                'sort_by': self.sort_direction
            }

            response = self.session.get(url, params=params, timeout=15)
            response.raise_for_status()

            data = response.json()
            
            if data.get('status') == 'ok' and data.get('data', {}).get('movies'):
                movies = data['data']['movies']
                safe_debug(f"Found {len(movies)} movies from YTS")
                return movies
            else:
                safe_debug("No movies found in YTS response")
                return []

        except Exception as e:
            safe_warning(f"YTS API error: {str(e)}")
            raise

    def _get_cached_result(self, key):
        """Get cached result if still valid"""
        if key in self.search_cache:
            cached = self.search_cache[key]
            if time.time() - cached['timestamp'] < self.cache_timeout:
                return cached['data']
            else:
                # Remove expired cache
                del self.search_cache[key]
        return None

    def _get_rating_info(self, rating):
        """Get rating icon and description based on rating"""
        if rating >= 8.5:
            return self.rating_icons['excellent'], "Excellent"
        elif rating >= 7.0:
            return self.rating_icons['great'], "Great"
        elif rating >= 6.0:
            return self.rating_icons['good'], "Good"
        elif rating >= 4.0:
            return self.rating_icons['average'], "Average"
        elif rating > 0:
            return self.rating_icons['poor'], "Poor"
        else:
            return self.rating_icons['unrated'], "Unrated"

    def _build_magnet_uri(self, torrent_hash, movie_title):
        """Build magnet URI from torrent hash"""
        magnet_uri = f"magnet:?xt=urn:btih:{torrent_hash}"
        magnet_uri += f"&dn={urllib.parse.quote(movie_title)}"
        
        # Add trackers
        for tracker in self.trackers:
            magnet_uri += f"&tr={urllib.parse.quote(tracker)}"
        
        return magnet_uri

    def _stream_movie(self, magnet_uri):
        """Stream movie using WebTorrent"""
        try:
            safe_info("Starting movie stream...")
            
            # Ensure download directory exists
            os.makedirs(self.download_path, exist_ok=True)
            
            cmd = self._build_stream_command(magnet_uri)
            
            subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            
            effective_player = self._get_effective_player()
            safe_info(f"Stream started successfully with {effective_player}")
            
        except Exception as e:
            safe_warning(f"Failed to start stream: {e}")

    def _download_movie(self, magnet_uri):
        """Download movie using WebTorrent"""
        try:
            safe_info("Starting movie download...")
            
            # Ensure download directory exists
            os.makedirs(self.download_path, exist_ok=True)
            
            cmd = [
                "webtorrent",
                "download",
                magnet_uri,
                "--quiet",
                "--out", self.download_path
            ]
            
            subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            safe_info("Download started successfully")
            
        except Exception as e:
            safe_warning(f"Failed to start download: {e}")

    def _add_results_to_query(self, query, movies, search_term):
        """Add movie results to Albert query"""
        for movie in movies:
            title = movie.get('title', 'Unknown Title')
            year = movie.get('year', 'Unknown')
            rating = movie.get('rating', 0.0)
            runtime = movie.get('runtime', 0)
            genres = ', '.join(movie.get('genres', []))
            summary = movie.get('summary', 'No summary available')
            torrents = movie.get('torrents', [])
            
            # Get rating info
            rating_icon, rating_desc = self._get_rating_info(rating)
            
            # Create display text
            display_title = f"{rating_icon} {title} ({year})"
            
            # Create subtext with key information
            subtext_parts = []
            if rating > 0:
                subtext_parts.append(f"⭐ {rating}/10")
            if runtime:
                hours = runtime // 60
                minutes = runtime % 60
                if hours > 0:
                    subtext_parts.append(f"⏱️ {hours}h {minutes}m")
                else:
                    subtext_parts.append(f"⏱️ {minutes}m")
            if genres:
                subtext_parts.append(f"🎭 {genres}")
            
            subtext = " • ".join(subtext_parts) if subtext_parts else summary[:80] + "..."

            # Create item for movie selection
            item = albert.StandardItem(
                id=f"movie_{movie.get('id', 0)}",
                text=display_title,
                subtext=subtext,
                iconUrls=["video-x-generic", "applications-multimedia"],
                actions=[]
            )

            # Add actions based on available torrents
            actions = []
            
            if torrents:
                # Group torrents by quality
                quality_groups = {}
                for torrent in torrents:
                    quality = torrent.get('quality', 'Unknown')
                    if quality not in quality_groups:
                        quality_groups[quality] = []
                    quality_groups[quality].append(torrent)
                
                # Add actions for each quality
                for quality, quality_torrents in quality_groups.items():
                    # Use the first torrent of each quality (usually best seeds/peers)
                    torrent = quality_torrents[0]
                    torrent_hash = torrent.get('hash', '')
                    size = torrent.get('size', 'Unknown')
                    
                    if torrent_hash:
                        magnet_uri = self._build_magnet_uri(torrent_hash, title)
                        
                        # Stream action with player info
                        effective_player = self._get_effective_player()
                        player_display = effective_player if effective_player != "webtorrent_auto" else "Auto"
                        
                        actions.append(albert.Action(
                            f"stream_{quality}",
                            f"🎥 Stream {quality} ({size}) [{player_display}]",
                            lambda uri=magnet_uri: self._stream_movie(uri)
                        ))
                        
                        # Download action
                        actions.append(albert.Action(
                            f"download_{quality}",
                            f"📥 Download {quality} ({size})",
                            lambda uri=magnet_uri: self._download_movie(uri)
                        ))

            # Add info actions
            if movie.get('imdb_code'):
                imdb_url = f"https://www.imdb.com/title/{movie['imdb_code']}"
                actions.append(albert.Action(
                    "open_imdb",
                    "🌐 Open on IMDb",
                    lambda url=imdb_url: albert.openUrl(url)
                ))
            
            # YTS page
            yts_url = f"https://yts.mx/movies/{movie.get('slug', '')}"
            actions.append(albert.Action(
                "open_yts",
                "🌐 Open on YTS",
                lambda url=yts_url: albert.openUrl(url)
            ))

            # Copy movie info
            movie_info = f"{title} ({year}) - {rating}/10\n{summary}"
            actions.append(albert.Action(
                "copy_info",
                "📋 Copy Movie Info",
                lambda info=movie_info: albert.setClipboardText(info)
            ))

            item.actions = actions
            query.add(item)

        # Add warning about legal compliance
        query.add(albert.StandardItem(
            id="legal_warning",
            text="⚠️ Legal Notice",
            subtext="Ensure you have legal rights to access downloaded content",
            iconUrls=["dialog-warning"],
            actions=[
                albert.Action(
                    "legal_info",
                    "Legal Information",
                    lambda: albert.openUrl("https://en.wikipedia.org/wiki/Legal_issues_with_BitTorrent")
                )
            ]
        ))

    def finalize(self):
        """Clean up when plugin is disabled"""
        if hasattr(self, 'session'):
            self.session.close()