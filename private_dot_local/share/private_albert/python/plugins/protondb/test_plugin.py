#!/usr/bin/env python3
"""
Test script for ProtonDB Albert plugin

This script tests the plugin functionality outside of Albert
to verify the ProtonDB search and parsing works correctly.
"""

import sys
from pathlib import Path

# Add the plugin directory to Python path
plugin_dir = Path(__file__).parent
sys.path.insert(0, str(plugin_dir))

# Mock Albert module for testing
class MockAlbert:
    class StandardItem:
        def __init__(self, id, text, subtext, iconUrls=None, actions=None):
            self.id = id
            self.text = text
            self.subtext = subtext
            self.iconUrls = iconUrls or []
            self.actions = actions or []

        def __repr__(self):
            return f"Item(id='{self.id}', text='{self.text}', subtext='{self.subtext}')"

    class Action:
        def __init__(self, id, text, callback):
            self.id = id
            self.text = text
            self.callback = callback

        def __repr__(self):
            return f"Action(id='{self.id}', text='{self.text}')"

    class Query:
        def __init__(self, string):
            self.string = string
            self.items = []

        def add(self, item):
            self.items.append(item)

    class PluginInstance:
        def __init__(self):
            pass

        def dataLocation(self):
            return Path('/tmp/albert_test_data')

    class TriggerQueryHandler:
        pass

    @staticmethod
    def debug(msg):
        print(f"[DEBUG] {msg}")

    @staticmethod
    def info(msg):
        print(f"[INFO] {msg}")

    @staticmethod
    def warning(msg):
        print(f"[WARNING] {msg}")

    @staticmethod
    def critical(msg):
        print(f"[CRITICAL] {msg}")

    @staticmethod
    def openUrl(url):
        print(f"[ACTION] Open URL: {url}")

    @staticmethod
    def setClipboardText(text):
        print(f"[ACTION] Copy to clipboard: {text}")

# Mock the albert module
sys.modules['albert'] = MockAlbert()

# Now import our plugin
try:
    from __init__ import Plugin
    print("✓ Plugin imported successfully")
except ImportError as e:
    print(f"✗ Failed to import plugin: {e}")
    sys.exit(1)

def test_plugin_basic():
    """Test basic plugin functionality"""
    print("\n=== Testing Basic Plugin Functionality ===")

    plugin = Plugin()

    # Test metadata
    print(f"Plugin trigger: '{plugin.defaultTrigger()}'")
    print(f"Plugin synopsis: '{plugin.synopsis('')}'")
    print(f"Supports fuzzy matching: {plugin.supportsFuzzyMatching()}")

    assert plugin.defaultTrigger() == "proton "
    print("✓ Basic functionality tests passed")

def test_empty_query():
    """Test handling of empty queries"""
    print("\n=== Testing Empty Query ===")

    plugin = Plugin()
    query = MockAlbert.Query("")

    plugin.handleTriggerQuery(query)

    assert len(query.items) == 1
    assert "help" in query.items[0].id
    print("✓ Empty query handled correctly")

def test_short_query():
    """Test handling of short queries"""
    print("\n=== Testing Short Query ===")

    plugin = Plugin()
    query = MockAlbert.Query("a")

    plugin.handleTriggerQuery(query)

    assert len(query.items) == 1
    assert "short" in query.items[0].id
    print("✓ Short query handled correctly")

def test_game_search():
    """Test actual game search (requires internet)"""
    print("\n=== Testing Game Search ===")

    plugin = Plugin()

    # Test with a popular game
    test_games = ["cyberpunk", "witcher", "doom"]

    for game in test_games:
        print(f"\nSearching for: {game}")
        query = MockAlbert.Query(game)

        try:
            plugin.handleTriggerQuery(query)

            print(f"Found {len(query.items)} results:")
            for item in query.items:
                print(f"  - {item.text}")
                print(f"    {item.subtext}")
                if item.actions:
                    print(f"    Actions: {[a.text for a in item.actions]}")

            if query.items and "error" not in query.items[0].id:
                print(f"✓ Search for '{game}' successful")
            else:
                print(f"⚠ Search for '{game}' returned error or no results")

        except Exception as e:
            print(f"✗ Search for '{game}' failed: {e}")

def test_caching():
    """Test caching functionality"""
    print("\n=== Testing Caching ===")

    plugin = Plugin()

    # First search
    query1 = MockAlbert.Query("test")
    plugin.handleTriggerQuery(query1)

    # Check if cache was populated
    cache_key = "test"
    if cache_key in plugin.search_cache:
        print("✓ Cache populated after first search")

        # Second search (should use cache)
        query2 = MockAlbert.Query("test")
        plugin.handleTriggerQuery(query2)
        print("✓ Second search completed (likely from cache)")
    else:
        print("⚠ Cache not populated (may be due to no results)")

def test_rating_system():
    """Test rating system and visual indicators"""
    print("\n=== Testing Rating System ===")

    plugin = Plugin()

    # Test all rating types
    for rating, info in plugin.ratings.items():
        print(f"{rating.upper()}: {info['color']} - {info['description']}")

    assert len(plugin.ratings) == 6  # platinum, gold, silver, bronze, borked, pending
    print("✓ All rating types defined correctly")

def run_all_tests():
    """Run all tests"""
    print("ProtonDB Plugin Test Suite")
    print("=" * 50)

    try:
        test_plugin_basic()
        test_empty_query()
        test_short_query()
        test_rating_system()
        test_caching()

        # Network-dependent test (skip if no internet)
        try:
            test_game_search()
        except Exception as e:
            print(f"⚠ Network test skipped: {e}")

        print("\n" + "=" * 50)
        print("✓ All tests completed successfully!")

    except Exception as e:
        print(f"\n✗ Test failed: {e}")
        import traceback
        traceback.print_exc()
        return False

    return True

if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
