#!/usr/bin/env python3
"""
Test script for Movie Search & Stream plugin functionality
This script tests the search logic independently of Albert to help debug issues.
"""

import json
import sys
import time
import requests
import subprocess
import urllib.parse
import shutil
from pathlib import Path

class MovieSearchTester:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Movie Search Plugin Test/2.0',
            'Accept': 'application/json'
        })

        # YTS API configuration
        self.yts_api_base = "https://yts.mx/api/v2"
        
        # Default test settings
        self.search_limit = 5
        self.order_by = "rating"
        self.sort_direction = "desc"
        
        # Default trackers for testing magnet URIs
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

        # Rating descriptions
        self.rating_descriptions = {
            8.5: "⭐⭐⭐⭐⭐ Excellent",
            7.0: "⭐⭐⭐⭐ Great", 
            6.0: "⭐⭐⭐ Good",
            4.0: "⭐⭐ Average",
            0.1: "⭐ Poor",
            0.0: "❓ Unrated"
        }
        
        # Load configuration if available
        self._load_config()
        
        # Detect available players
        self.available_players = self._detect_available_players()
        self.system_default_player = self._get_system_default_player()

    def _load_config(self):
        """Load configuration from plugin config file"""
        config_paths = [
            Path.home() / '.local/share/albert/python/plugins/movies/data/config.json',
            Path(__file__).parent / 'data' / 'config.json',
            Path(__file__).parent / 'config.json'
        ]
        
        for config_path in config_paths:
            if config_path.exists():
                try:
                    with open(config_path, 'r') as f:
                        config = json.load(f)
                        
                    self.search_limit = config.get('search_limit', self.search_limit)
                    self.order_by = config.get('order_by', self.order_by)
                    self.sort_direction = config.get('sort_direction', self.sort_direction)
                    
                    custom_trackers = config.get('custom_trackers', [])
                    if custom_trackers:
                        self.default_trackers = custom_trackers
                        
                    print(f"✓ Loaded configuration from {config_path}")
                    return
                    
                except Exception as e:
                    print(f"⚠ Failed to load config from {config_path}: {e}")
        
        print("⚠ No configuration file found, using defaults")

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
                return player
        except (subprocess.TimeoutExpired, FileNotFoundError, Exception):
            pass
        
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

    def check_player_detection(self):
        """Check available media players"""
        print("\n" + "="*60)
        print("CHECKING MEDIA PLAYER DETECTION")
        print("="*60)
        
        if self.available_players:
            print(f"✓ Available players: {', '.join(self.available_players)}")
            
            for player in self.available_players:
                try:
                    result = subprocess.run([player, '--version'], 
                                          capture_output=True, text=True, timeout=5)
                    if result.returncode == 0:
                        version_line = result.stdout.split('\n')[0]
                        print(f"  - {player}: {version_line}")
                    else:
                        print(f"  - {player}: Available but version check failed")
                except Exception as e:
                    print(f"  - {player}: Available but error getting version: {e}")
        else:
            print("❌ No supported media players found!")
            print("Please install one of: VLC, MPV, MPlayer, SMPlayer, Kodi")
        
        if self.system_default_player:
            print(f"✓ System default player: {self.system_default_player}")
        else:
            print("⚠ Could not detect system default player")
            
        # Test WebTorrent CLI player detection
        try:
            result = subprocess.run(['webtorrent', '--help'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0 and '--vlc' in result.stdout:
                print("✓ WebTorrent CLI supports player integration")
            else:
                print("⚠ WebTorrent CLI may not support player integration")
        except Exception as e:
            print(f"⚠ Could not test WebTorrent CLI: {e}")

    def check_configuration(self):
        """Check plugin configuration"""
        print("\n" + "="*60)
        print("CHECKING PLUGIN CONFIGURATION")
        print("="*60)
        
        config_path = Path.home() / '.local/share/albert/python/plugins/movies/data/config.json'
        
        if config_path.exists():
            try:
                with open(config_path, 'r') as f:
                    config = json.load(f)
                
                print(f"✓ Configuration file found: {config_path}")
                print("Current settings:")
                for key, value in config.items():
                    if key == 'custom_trackers' and isinstance(value, list):
                        print(f"  {key}: {len(value)} trackers configured")
                    else:
                        print(f"  {key}: {value}")
                        
                # Check download path
                download_path = Path(config.get('download_path', '~/Downloads/Movies')).expanduser()
                if download_path.exists():
                    print(f"✓ Download directory exists: {download_path}")
                else:
                    print(f"⚠ Download directory does not exist: {download_path}")
                
                # Check player configuration
                default_player = config.get('default_player', 'auto')
                print(f"Configured player: {default_player}")
                
                if default_player != 'auto' and default_player not in self.available_players:
                    print(f"⚠ Configured player '{default_player}' is not available")
                    
            except Exception as e:
                print(f"❌ Error reading configuration: {e}")
        else:
            print(f"❌ Configuration file not found: {config_path}")
            print("Run the plugin once to create default configuration")

    def check_dependencies(self):
        """Check if required dependencies are installed"""
        print("Checking dependencies...")
        
        missing_deps = []
        
        # Check WebTorrent CLI
        try:
            result = subprocess.run(['webtorrent', '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                print(f"✓ WebTorrent CLI: {result.stdout.strip()}")
            else:
                missing_deps.append("webtorrent-cli")
        except (subprocess.TimeoutExpired, FileNotFoundError):
            missing_deps.append("webtorrent-cli")
            
        # Check VLC
        try:
            result = subprocess.run(['vlc', '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                print("✓ VLC Media Player: Installed")
            else:
                missing_deps.append("vlc")
        except (subprocess.TimeoutExpired, FileNotFoundError):
            missing_deps.append("vlc")
            
        # Check Mullvad (optional)
        try:
            result = subprocess.run(['mullvad', 'status'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                print(f"✓ Mullvad VPN: {result.stdout.strip()}")
            else:
                print("⚠ Mullvad VPN: Not configured")
        except (subprocess.TimeoutExpired, FileNotFoundError):
            print("⚠ Mullvad VPN: Not installed (optional)")
            
        if missing_deps:
            print(f"\n❌ Missing dependencies: {', '.join(missing_deps)}")
            print("Please install missing dependencies:")
            if "webtorrent-cli" in missing_deps:
                print("  npm install -g webtorrent-cli")
            if "vlc" in missing_deps:
                print("  sudo apt install vlc  # Ubuntu/Debian")
                print("  sudo dnf install vlc  # Fedora")
                print("  sudo pacman -S vlc   # Arch Linux")
            return False
        else:
            print("✓ All dependencies satisfied")
            return True

    def test_yts_api(self):
        """Test YTS API connectivity"""
        print("\n" + "="*60)
        print("TESTING YTS API CONNECTIVITY")
        print("="*60)
        
        try:
            # Test basic API endpoint
            url = f"{self.yts_api_base}/list_movies.json"
            params = {'limit': 1}
            
            response = self.session.get(url, params=params, timeout=10)
            response.raise_for_status()
            
            data = response.json()
            
            if data.get('status') == 'ok':
                print("✓ YTS API is accessible")
                movie_count = data.get('data', {}).get('movie_count', 0)
                print(f"✓ Total movies in database: {movie_count:,}")
                return True
            else:
                print(f"⚠ YTS API returned status: {data.get('status')}")
                return False
                
        except Exception as e:
            print(f"❌ YTS API test failed: {e}")
            return False

    def search_movies(self, query):
        """Search for movies using YTS API"""
        try:
            print(f"Searching YTS for: '{query}'")
            
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
                print(f"Found {len(movies)} movies")
                return movies
            else:
                print("No movies found in response")
                return []

        except Exception as e:
            print(f"❌ Search failed: {e}")
            return []

    def get_rating_display(self, rating):
        """Get rating display based on rating value"""
        for threshold, description in sorted(self.rating_descriptions.items(), reverse=True):
            if rating >= threshold:
                return description
        return "❓ Unrated"

    def build_magnet_uri(self, torrent_hash, movie_title):
        """Build magnet URI from torrent hash"""
        magnet_uri = f"magnet:?xt=urn:btih:{torrent_hash}"
        magnet_uri += f"&dn={urllib.parse.quote(movie_title)}"
        
        # Add trackers
        for tracker in self.default_trackers:
            magnet_uri += f"&tr={urllib.parse.quote(tracker)}"
        
        return magnet_uri

    def test_magnet_generation(self, movie):
        """Test magnet URI generation"""
        torrents = movie.get('torrents', [])
        if not torrents:
            print("  No torrents available for magnet testing")
            return
            
        print(f"  Testing magnet URI generation...")
        for torrent in torrents:
            quality = torrent.get('quality', 'Unknown')
            torrent_hash = torrent.get('hash', '')
            
            if torrent_hash:
                magnet_uri = self.build_magnet_uri(torrent_hash, movie.get('title', 'Unknown'))
                print(f"    {quality}: magnet:?xt=urn:btih:{torrent_hash}...")
                print(f"    Full URI length: {len(magnet_uri)} chars")
            else:
                print(f"    {quality}: No hash available")

    def test_streaming_simulation(self, movie, quality_filter=None):
        """Simulate streaming command without actually executing it"""
        torrents = movie.get('torrents', [])
        if not torrents:
            print("  No torrents available for streaming simulation")
            return
            
        print(f"  Simulating streaming commands...")
        
        for torrent in torrents:
            quality = torrent.get('quality', 'Unknown')
            
            if quality_filter and quality != quality_filter:
                continue
                
            torrent_hash = torrent.get('hash', '')
            size = torrent.get('size', 'Unknown')
            
            if torrent_hash:
                magnet_uri = self.build_magnet_uri(torrent_hash, movie.get('title', 'Unknown'))
                
                # Simulate streaming command
                stream_cmd = [
                    "webtorrent", 
                    magnet_uri,
                    "--quiet",
                    "--vlc",
                    "--out", "~/Downloads/Movies"
                ]
                
                # Simulate download command
                download_cmd = [
                    "webtorrent",
                    "download",
                    magnet_uri,
                    "--quiet",
                    "--out", "~/Downloads/Movies"
                ]
                
                print(f"    Stream {quality} ({size}):")
                print(f"      Command: {' '.join(stream_cmd[:3])} [magnet-uri] {' '.join(stream_cmd[3:])}")
                print(f"    Download {quality} ({size}):")
                print(f"      Command: {' '.join(download_cmd[:4])} [magnet-uri] {' '.join(download_cmd[4:])}")

    def test_search(self, query, detailed=True):
        """Test the complete search functionality"""
        print(f"\n{'='*60}")
        print(f"TESTING MOVIE SEARCH: '{query}'")
        print(f"{'='*60}")

        # Search for movies
        movies = self.search_movies(query)

        if not movies:
            print("❌ No movies found")
            return

        # Display results
        print(f"\nFound {len(movies)} movies:")
        
        for i, movie in enumerate(movies, 1):
            title = movie.get('title', 'Unknown Title')
            year = movie.get('year', 'Unknown')
            rating = movie.get('rating', 0.0)
            runtime = movie.get('runtime', 0)
            genres = ', '.join(movie.get('genres', []))
            summary = movie.get('summary', 'No summary available')
            torrents = movie.get('torrents', [])
            
            rating_display = self.get_rating_display(rating)
            
            print(f"\n{i}. {rating_display} {title} ({year})")
            print(f"   Rating: {rating}/10")
            
            if runtime:
                hours = runtime // 60
                minutes = runtime % 60
                if hours > 0:
                    print(f"   Runtime: {hours}h {minutes}m")
                else:
                    print(f"   Runtime: {minutes}m")
                    
            if genres:
                print(f"   Genres: {genres}")
                
            print(f"   Summary: {summary[:100]}{'...' if len(summary) > 100 else ''}")
            
            # Show available torrents
            if torrents:
                print(f"   Available torrents:")
                for torrent in torrents:
                    quality = torrent.get('quality', 'Unknown')
                    size = torrent.get('size', 'Unknown')
                    seeds = torrent.get('seeds', 0)
                    peers = torrent.get('peers', 0)
                    print(f"     - {quality}: {size} (Seeds: {seeds}, Peers: {peers})")
            else:
                print("   No torrents available")
                
            # Additional testing if detailed
            if detailed and torrents:
                self.test_magnet_generation(movie)
                self.test_streaming_simulation(movie)

    def run_interactive_test(self):
        """Run interactive testing mode"""
        print("Interactive Movie Search & Stream Tester")
        print("Commands:")
        print("  - Enter movie title to search")
        print("  - 'config' to check configuration")
        print("  - 'players' to check media players")
        print("  - 'deps' to check dependencies")
        print("  - 'api' to test YTS API")
        print("  - 'detailed <movie>' for detailed search")
        print("  - 'quick <movie>' for quick search")
        print("  - 'quit' to exit")
        print()

        while True:
            try:
                user_input = input("Enter command or movie title: ").strip()
                
                if user_input.lower() in ['quit', 'exit', 'q']:
                    break
                    
                if not user_input:
                    continue
                    
                # Parse commands
                if user_input.lower() == 'config':
                    self.check_configuration()
                elif user_input.lower() == 'players':
                    self.check_player_detection()
                elif user_input.lower() == 'deps':
                    self.check_dependencies()
                elif user_input.lower() == 'api':
                    self.test_yts_api()
                elif user_input.startswith('detailed '):
                    query = user_input[9:]
                    self.test_search(query, detailed=True)
                elif user_input.startswith('quick '):
                    query = user_input[6:]
                    self.test_search(query, detailed=False)
                else:
                    # Default to detailed search
                    self.test_search(user_input, detailed=True)

            except KeyboardInterrupt:
                print("\nExiting...")
                break

    def run_predefined_tests(self):
        """Run a set of predefined tests"""
        test_movies = [
            "the matrix",
            "inception", 
            "pulp fiction",
            "the godfather",
            "star wars",
            "avengers",
            "interstellar",
            "the dark knight"
        ]

        print("Running predefined tests...")
        for movie in test_movies:
            self.test_search(movie, detailed=False)
            print("\n" + "-"*60 + "\n")
            time.sleep(1)  # Be nice to the API

    def test_full_workflow(self):
        """Test the complete workflow"""
        print("\n" + "="*60)
        print("TESTING COMPLETE WORKFLOW")
        print("="*60)
        
        # Test dependencies
        if not self.check_dependencies():
            print("❌ Dependencies check failed - some features may not work")
            
        # Test API
        if not self.test_yts_api():
            print("❌ API test failed - searches will not work")
            return
            
        # Test search
        print("\nTesting search with 'inception'...")
        movies = self.search_movies("inception")
        
        if movies:
            movie = movies[0]  # Test with first result
            print(f"\nTesting workflow with: {movie.get('title', 'Unknown')}")
            
            # Test magnet generation
            self.test_magnet_generation(movie)
            
            # Test command simulation
            self.test_streaming_simulation(movie)
            
            print("\n✓ Full workflow test completed successfully")
        else:
            print("❌ No movies found for workflow testing")

def main():
    tester = MovieSearchTester()

    print("Movie Search & Stream Plugin Test Suite")
    print("=" * 50)
    print("⚠️  LEGAL NOTICE: This tool tests torrent functionality.")
    print("   Only use for content you have legal rights to access.")
    print("=" * 50)

    if len(sys.argv) > 1:
        # Handle command line arguments
        if sys.argv[1] == "--test-config":
            tester.check_configuration()
        elif sys.argv[1] == "--test-deps":
            tester.check_dependencies()
        elif sys.argv[1] == "--test-api":
            tester.test_yts_api()
        elif sys.argv[1] == "--test-all":
            tester.run_predefined_tests()
        elif sys.argv[1] == "--test-workflow":
            tester.test_full_workflow()
        else:
            # Test specific movie from command line
            query = " ".join(sys.argv[1:])
            tester.test_search(query)
    else:
        # Ask user what to do
        print("\nChoose test mode:")
        print("1. Interactive testing")
        print("2. Predefined tests")
        print("3. Full workflow test")
        print("4. Configuration check")
        print("5. Media player check")
        print("6. Dependencies check")
        print("7. API connectivity test")
        print("8. Exit")

        try:
            choice = input("Enter choice (1-8): ").strip()

            if choice == "1":
                tester.run_interactive_test()
            elif choice == "2":
                tester.run_predefined_tests()
            elif choice == "3":
                tester.test_full_workflow()
            elif choice == "4":
                tester.check_configuration()
            elif choice == "5":
                tester.check_player_detection()
            elif choice == "6":
                tester.check_dependencies()
            elif choice == "7":
                tester.test_yts_api()
            elif choice == "8":
                print("Exiting...")
            else:
                print("Invalid choice")
                
        except KeyboardInterrupt:
            print("\nExiting...")

if __name__ == "__main__":
    main()