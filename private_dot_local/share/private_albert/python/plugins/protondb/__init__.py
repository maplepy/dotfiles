"""
ProtonDB Search Plugin for Albert

Search for game compatibility ratings on ProtonDB directly from Albert.
Usage: proton <game name>

Based on the approach used by ulauncher-protondb-search plugin.
"""

# Mandatory metadata
md_iid = "3.0"
md_version = "1.0"
md_name = "ProtonDB Search"
md_description = "Search game compatibility on ProtonDB"

# Optional metadata
md_license = "MIT"
md_url = "https://github.com/maplepy/albert-plugins"
md_authors = ["maplepy"]
md_bin_dependencies = []
md_lib_dependencies = ["requests"]

import albert
import requests
import json
import time
import os
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

def check_albert_api():
    """Check which Albert API functions are available"""
    available_functions = []
    missing_functions = []

    functions_to_check = ['debug', 'info', 'warning', 'critical']

    for func_name in functions_to_check:
        if hasattr(albert, func_name):
            available_functions.append(func_name)
        else:
            missing_functions.append(func_name)

    if missing_functions:
        print(f"Albert API - Missing functions: {', '.join(missing_functions)}")
        print(f"Albert API - Available functions: {', '.join(available_functions)}")
        print("This may indicate an Albert version compatibility issue.")

    return available_functions, missing_functions

class Plugin(albert.PluginInstance, albert.TriggerQueryHandler):

    def __init__(self):
        albert.PluginInstance.__init__(self)
        albert.TriggerQueryHandler.__init__(self)

        # Check Albert API compatibility
        available_funcs, missing_funcs = check_albert_api()
        if missing_funcs:
            print(f"ProtonDB Plugin: Some Albert logging functions are not available: {missing_funcs}")

        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0',
            'Referer': '-'
        })

        # Cache for search results and Steam API data
        self.search_cache = {}
        self.cache_timeout = 300  # 5 minutes

        # Steam API data file
        self.steam_api_file = os.path.join(str(self.dataLocation()), 'steamapi.json')
        self.steam_api_data = None
        self.steam_api_age = 0

        # ProtonDB API endpoints
        self.pdb_api = 'https://www.protondb.com/api/v1/reports/summaries/'
        self.steam_api = 'https://api.steampowered.com/ISteamApps/GetAppList/v2/'

        # ProtonDB rating colors and descriptions
        self.ratings = {
            'platinum': {
                'color': '🥇',
                'description': 'Perfect - Runs flawlessly out of the box',
                'icon': 'emblem-favorite'
            },
            'gold': {
                'color': '🥇',
                'description': 'Great - Runs perfectly after tweaks',
                'icon': 'emblem-important'
            },
            'silver': {
                'color': '🥈',
                'description': 'Good - Runs with minor issues',
                'icon': 'emblem-default'
            },
            'bronze': {
                'color': '🥉',
                'description': 'Okay - Runs with significant issues',
                'icon': 'emblem-symbolic-link'
            },
            'borked': {
                'color': '💀',
                'description': 'Broken - Does not run',
                'icon': 'emblem-unreadable'
            },
            'pending': {
                'color': '❓',
                'description': 'Unknown - No reports yet',
                'icon': 'emblem-question'
            }
        }

        # Initialize Steam API data
        self._load_steam_api_data()

    def defaultTrigger(self):
        return "proton "

    def synopsis(self, query):
        return "ProtonDB: proton <game name>"

    def supportsFuzzyMatching(self):
        return False

    def handleTriggerQuery(self, query):
        search_term = query.string.strip()

        if not search_term:
            query.add(albert.StandardItem(
                id="protondb_help",
                text="ProtonDB Game Search",
                subtext="Enter a game name to search for compatibility ratings",
                iconUrls=["xdg:applications-games"],
                actions=[]
            ))
            return

        if len(search_term) < 2:
            query.add(albert.StandardItem(
                id="protondb_short",
                text="Search term too short",
                subtext="Please enter at least 2 characters",
                iconUrls=["dialog-warning"],
                actions=[]
            ))
            return

        # Check if Steam API data is available
        if not self.steam_api_data:
            query.add(albert.StandardItem(
                id="protondb_no_steam_data",
                text="Steam API data not available",
                subtext="Click to download Steam game list (required for search)",
                iconUrls=["dialog-information"],
                actions=[
                    albert.Action(
                        "download_steam_data",
                        "Download Steam game list",
                        lambda: self._download_steam_api_data()
                    )
                ]
            ))
            return

        # Check cache first
        cache_key = search_term.lower()
        cached_result = self._get_cached_result(cache_key)

        if cached_result:
            self._add_results_to_query(query, cached_result, search_term)
            return

        try:
            # Search for games in Steam API data
            matching_games = self._search_steam_games(search_term)

            if not matching_games:
                query.add(albert.StandardItem(
                    id="protondb_no_results",
                    text="No games found",
                    subtext=f"No Steam games found matching '{search_term}'",
                    iconUrls=["dialog-information"],
                    actions=[
                        albert.Action(
                            "search_web",
                            "Search on ProtonDB website",
                            lambda: albert.openUrl(f"https://www.protondb.com/search?q={quote_plus(search_term)}")
                        )
                    ]
                ))
                return

            # Get ProtonDB ratings for found games
            results = self._get_protondb_ratings(matching_games[:5])  # Limit to 5 games

            if results:
                # Cache results
                self.search_cache[cache_key] = {
                    'data': results,
                    'timestamp': time.time()
                }
                self._add_results_to_query(query, results, search_term)
            else:
                query.add(albert.StandardItem(
                    id="protondb_no_ratings",
                    text="No ProtonDB data found",
                    subtext="Games found but no ProtonDB ratings available",
                    iconUrls=["dialog-information"],
                    actions=[]
                ))

        except Exception as e:
            safe_warning(f"ProtonDB search failed: {str(e)}")
            query.add(albert.StandardItem(
                id="protondb_error",
                text="Search failed",
                subtext=f"Error: {str(e)[:50]}...",
                iconUrls=["dialog-error"],
                actions=[
                    albert.Action(
                        "search_web",
                        "Open ProtonDB website",
                        lambda: albert.openUrl("https://www.protondb.com")
                    )
                ]
            ))

    def _load_steam_api_data(self):
        """Load Steam API data from file"""
        try:
            if os.path.exists(self.steam_api_file):
                # Check if file is recent (less than 7 days old)
                file_age = time.time() - os.path.getmtime(self.steam_api_file)
                if file_age < 604800:  # 7 days in seconds
                    with open(self.steam_api_file, 'r', encoding='utf-8') as f:
                        self.steam_api_data = json.load(f)
                        self.steam_api_age = file_age
                        safe_debug(f"Loaded Steam API data ({len(self.steam_api_data.get('applist', {}).get('apps', []))} games)")
                        return
                else:
                    safe_debug("Steam API data is older than 7 days, will download fresh data")

            # Try to download fresh data
            self._download_steam_api_data()

        except Exception as e:
            safe_warning(f"Failed to load Steam API data: {str(e)}")
            self.steam_api_data = None

    def _download_steam_api_data(self):
        """Download Steam API data"""
        try:
            safe_info("Downloading Steam game list...")

            # Ensure data directory exists
            os.makedirs(os.path.dirname(self.steam_api_file), exist_ok=True)

            response = self.session.get(self.steam_api, timeout=30)
            response.raise_for_status()

            data = response.json()

            # Save to file
            with open(self.steam_api_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)

            self.steam_api_data = data
            safe_info(f"Downloaded Steam API data ({len(data.get('applist', {}).get('apps', []))} games)")

        except Exception as e:
            safe_critical(f"Failed to download Steam API data: {str(e)}")
            raise

    def _search_steam_games(self, query):
        """Search for games in Steam API data"""
        if not self.steam_api_data or 'applist' not in self.steam_api_data:
            return []

        query_lower = query.lower().strip()
        exact_matches = []
        startswith_matches = []
        contains_matches = []

        for app in self.steam_api_data['applist']['apps']:
            if not app.get('name'):
                continue

            app_name = app['name'].lower().strip()

            # Skip obviously non-game entries (demos, trailers, etc.)
            if any(skip_word in app_name for skip_word in ['demo', 'trailer', 'teaser', 'beta test', 'playtest']):
                continue

            # Categorize matches by quality
            if app_name == query_lower:
                exact_matches.append({
                    'name': app['name'],
                    'appid': app['appid'],
                    'name_length': len(app['name']),
                    'match_type': 'exact'
                })
            elif app_name.startswith(query_lower):
                startswith_matches.append({
                    'name': app['name'],
                    'appid': app['appid'],
                    'name_length': len(app['name']),
                    'match_type': 'startswith'
                })
            elif query_lower in app_name:
                contains_matches.append({
                    'name': app['name'],
                    'appid': app['appid'],
                    'name_length': len(app['name']),
                    'match_type': 'contains'
                })

        # Sort each category by name length (shorter = better match)
        exact_matches.sort(key=lambda x: x['name_length'])
        startswith_matches.sort(key=lambda x: x['name_length'])
        contains_matches.sort(key=lambda x: x['name_length'])

        # Combine results with exact matches first
        matching_games = exact_matches + startswith_matches + contains_matches

        return matching_games

    def _get_protondb_ratings(self, games):
        """Get ProtonDB ratings for a list of games"""
        results = []

        for game in games:
            try:
                appid = game['appid']
                rating = self._get_protondb_rating(appid)

                if rating and rating != "Not Found":
                    results.append({
                        'name': game['name'],
                        'appid': appid,
                        'rating': rating.lower(),
                        'total_reports': 0  # ProtonDB API doesn't easily provide this
                    })

                # Sleep to prevent hammering the server
                time.sleep(0.2)

            except Exception as e:
                safe_debug(f"Failed to get rating for {game['name']}: {str(e)}")
                continue

        return results

    def _get_protondb_rating(self, appid):
        """Get ProtonDB rating for a specific Steam app ID"""
        try:
            url = f"{self.pdb_api}{appid}.json"
            response = self.session.get(url, timeout=10)

            if response.status_code == 200:
                data = response.json()
                return data.get("tier")
            else:
                return None

        except Exception as e:
            safe_debug(f"ProtonDB API error for app {appid}: {str(e)}")
            return None

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

    def _add_results_to_query(self, query, results, search_term):
        """Add search results to Albert query"""
        for game in results:
            rating = game.get('rating', 'pending').lower()
            rating_info = self.ratings.get(rating, self.ratings['pending'])

            app_id = game.get('appid', '')
            game_name = game.get('name', 'Unknown Game')

            # Create subtext with rating info
            subtext = rating_info['description']

            # Create item
            item = albert.StandardItem(
                id=f"protondb_{app_id}",
                text=f"{rating_info['color']} {game_name}",
                subtext=subtext,
                iconUrls=[f"xdg:{rating_info['icon']}", "xdg:applications-games"],
                actions=[]
            )

            # Add actions
            actions = []

            if app_id:
                # Open ProtonDB page
                protondb_url = f"https://www.protondb.com/app/{app_id}"
                actions.append(albert.Action(
                    "open_protondb",
                    "Open on ProtonDB",
                    lambda url=protondb_url: albert.openUrl(url)
                ))

                # Open Steam page
                steam_url = f"https://store.steampowered.com/app/{app_id}"
                actions.append(albert.Action(
                    "open_steam",
                    "Open on Steam",
                    lambda url=steam_url: albert.openUrl(url)
                ))

            # Copy game info
            game_info = f"{game_name} - {rating_info['description']}"
            actions.append(albert.Action(
                "copy_info",
                "Copy game info",
                lambda info=game_info: albert.setClipboardText(info)
            ))

            item.actions = actions
            query.add(item)

        # Add "Search more on ProtonDB" option
        if results:
            query.add(albert.StandardItem(
                id="protondb_more",
                text="Search more on ProtonDB",
                subtext=f"Open ProtonDB search for '{search_term}'",
                iconUrls=["xdg:web-browser"],
                actions=[
                    albert.Action(
                        "search_more",
                        "Search on ProtonDB",
                        lambda: albert.openUrl(f"https://www.protondb.com/search?q={quote_plus(search_term)}")
                    )
                ]
            ))

    def finalize(self):
        """Clean up when plugin is disabled"""
        if hasattr(self, 'session'):
            self.session.close()
