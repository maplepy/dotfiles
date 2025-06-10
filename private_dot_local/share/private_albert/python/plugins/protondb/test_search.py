#!/usr/bin/env python3
"""
Test script for ProtonDB plugin search functionality
This script tests the search logic independently of Albert to help debug issues.
"""

import json
import sys
import time
import requests
from pathlib import Path

class ProtonDBTester:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0',
            'Referer': '-'
        })

        # API endpoints
        self.pdb_api = 'https://www.protondb.com/api/v1/reports/summaries/'
        self.steam_api = 'https://api.steampowered.com/ISteamApps/GetAppList/v2/'

        # Test data location
        self.test_data_dir = Path(__file__).parent / 'test_data'
        self.steam_api_file = self.test_data_dir / 'steamapi.json'

        self.steam_api_data = None

        # ProtonDB ratings
        self.ratings = {
            'platinum': '🥇 Perfect - Runs flawlessly out of the box',
            'gold': '🥇 Great - Runs perfectly after tweaks',
            'silver': '🥈 Good - Runs with minor issues',
            'bronze': '🥉 Okay - Runs with significant issues',
            'borked': '💀 Broken - Does not run',
            'pending': '❓ Unknown - No reports yet'
        }

    def setup_test_environment(self):
        """Set up test environment and download Steam API data if needed"""
        print("Setting up test environment...")

        # Create test data directory
        self.test_data_dir.mkdir(exist_ok=True)

        # Check if Steam API data exists and is recent
        if self.steam_api_file.exists():
            file_age = time.time() - self.steam_api_file.stat().st_mtime
            if file_age < 604800:  # 7 days
                print(f"Using existing Steam API data (age: {file_age/3600:.1f} hours)")
                self._load_steam_api_data()
                return

        # Download fresh Steam API data
        print("Downloading Steam API data...")
        self._download_steam_api_data()

    def _download_steam_api_data(self):
        """Download Steam API data"""
        try:
            response = self.session.get(self.steam_api, timeout=30)
            response.raise_for_status()

            data = response.json()

            # Save to file
            with open(self.steam_api_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)

            self.steam_api_data = data
            game_count = len(data.get('applist', {}).get('apps', []))
            print(f"Downloaded Steam API data: {game_count} games")

        except Exception as e:
            print(f"ERROR: Failed to download Steam API data: {e}")
            sys.exit(1)

    def _load_steam_api_data(self):
        """Load Steam API data from file"""
        try:
            with open(self.steam_api_file, 'r', encoding='utf-8') as f:
                self.steam_api_data = json.load(f)

            game_count = len(self.steam_api_data.get('applist', {}).get('apps', []))
            print(f"Loaded Steam API data: {game_count} games")

        except Exception as e:
            print(f"ERROR: Failed to load Steam API data: {e}")
            sys.exit(1)

    def search_steam_games(self, query):
        """Search for games in Steam API data"""
        if not self.steam_api_data or 'applist' not in self.steam_api_data:
            print("ERROR: Steam API data not available")
            return []

        query_lower = query.lower().strip()
        exact_matches = []
        startswith_matches = []
        contains_matches = []

        print(f"Searching for '{query}' in Steam database...")

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

        print(f"Found {len(matching_games)} matching games")
        print(f"  - Exact matches: {len(exact_matches)}")
        print(f"  - Starts with matches: {len(startswith_matches)}")
        print(f"  - Contains matches: {len(contains_matches)}")
        return matching_games

    def get_protondb_rating(self, appid):
        """Get ProtonDB rating for a specific Steam app ID"""
        try:
            url = f"{self.pdb_api}{appid}.json"
            print(f"Checking ProtonDB for app {appid}...")

            response = self.session.get(url, timeout=10)

            if response.status_code == 200:
                data = response.json()
                rating = data.get("tier")
                print(f"  -> Rating: {rating}")
                return rating
            elif response.status_code == 404:
                print(f"  -> No data found (404)")
                return None
            else:
                print(f"  -> HTTP {response.status_code}")
                return None

        except Exception as e:
            print(f"  -> Error: {e}")
            return None

    def test_search(self, query, max_results=3):
        """Test the complete search functionality"""
        print(f"\n{'='*60}")
        print(f"TESTING SEARCH: '{query}'")
        print(f"{'='*60}")

        # Step 1: Search Steam games
        matching_games = self.search_steam_games(query)

        if not matching_games:
            print("❌ No games found in Steam database")
            return

        # Step 2: Show first few matches
        print(f"\nTop {min(len(matching_games), max_results)} matches:")
        for i, game in enumerate(matching_games[:max_results]):
            print(f"  {i+1}. {game['name']} (ID: {game['appid']})")

        # Step 3: Get ProtonDB ratings
        print(f"\nGetting ProtonDB ratings...")
        results = []

        for game in matching_games[:max_results]:
            rating = self.get_protondb_rating(game['appid'])

            if rating:
                results.append({
                    'name': game['name'],
                    'appid': game['appid'],
                    'rating': rating.lower()
                })

            # Rate limiting
            time.sleep(0.5)

        # Step 4: Display results
        print(f"\n{'='*40}")
        print("FINAL RESULTS:")
        print(f"{'='*40}")

        if not results:
            print("❌ No ProtonDB data found for any matches")
        else:
            for result in results:
                rating = result['rating']
                rating_desc = self.ratings.get(rating, f"❓ {rating}")
                print(f"🎮 {result['name']}")
                print(f"   {rating_desc}")
                print(f"   ProtonDB: https://www.protondb.com/app/{result['appid']}")
                print(f"   Steam: https://store.steampowered.com/app/{result['appid']}")
                print()

    def run_interactive_test(self):
        """Run interactive testing mode"""
        print("Interactive ProtonDB Search Tester")
        print("Type 'quit' to exit")
        print()

        while True:
            try:
                query = input("Enter game name to search: ").strip()
                if query.lower() in ['quit', 'exit', 'q']:
                    break

                if not query:
                    continue

                self.test_search(query)

            except KeyboardInterrupt:
                print("\nExiting...")
                break

    def run_predefined_tests(self):
        """Run a set of predefined tests"""
        test_games = [
            "cyberpunk",
            "witcher 3",
            "doom eternal",
            "half life",
            "counter strike",
            "portal 2",
            "sekiro",
            "elden ring"
        ]

        print("Running predefined tests...")
        for game in test_games:
            self.test_search(game, max_results=2)
            print("\n" + "-"*60 + "\n")

def main():
    tester = ProtonDBTester()

    # Setup
    tester.setup_test_environment()

    if len(sys.argv) > 1:
        # Test specific game from command line
        query = " ".join(sys.argv[1:])
        tester.test_search(query)
    else:
        # Ask user what to do
        print("\nChoose test mode:")
        print("1. Interactive testing")
        print("2. Predefined tests")
        print("3. Exit")

        choice = input("Enter choice (1-3): ").strip()

        if choice == "1":
            tester.run_interactive_test()
        elif choice == "2":
            tester.run_predefined_tests()
        elif choice == "3":
            print("Exiting...")
        else:
            print("Invalid choice")

if __name__ == "__main__":
    main()
