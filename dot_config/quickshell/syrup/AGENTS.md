# AGENTS.md - Syrup Quickshell Configuration

## Overview

Syrup is a Quickshell desktop shell configuration based on Illogical Impulse (ii). It consists of QML files for the UI/services and Python utility scripts for translations and theming.

## Project Structure

```
syrup/
├── shell.qml                 # Entry point
├── GlobalStates.qml          # Runtime UI state
├── config.json               # User configuration
├── services/                 # 35+ feature singletons (Audio, Network, etc.)
├── modules/
│   ├── common/               # Shared infrastructure (Config, Appearance, widgets)
│   ├── ii/                   # Illogical Impulse panel family
│   └── settings/             # Settings UI pages
├── panelFamilies/            # Panel family loaders
├── scripts/                  # Python utility scripts
└── translations/             # i18n JSON files + Python tools
```

## Running the Project

```bash
cd ~/.config/quickshell/syrup
quickshell
```

For verbose logging:
```bash
quickshell -vv
```

## Build/Lint/Test Commands

There is **no build system** - QML files are loaded directly by Quickshell at runtime.

**QML Formatting:**
```bash
qmlformat -i <file.qml>           # Format a single file
qmlformat -i services/*.qml        # Format multiple files
```

Configuration is in `.qmlformat.ini`:
- Indent: 4 spaces (no tabs)
- Max column: 110
- Object spacing: enabled
- Function spacing: disabled

**Python Scripts:**
```bash
# Translation tools
./translations/tools/manage-translations.sh    # Main translation management
python translations/tools/translation-manager.py --help
python translations/tools/translation-cleaner.py --help

# Thumbnail generation
python scripts/thumbnails/thumbgen.py --help

# Color scheme generation
python scripts/colors/generate_colors_material.py
```

**No tests exist** in this project.

## Code Style - QML

### File Header
```qml
pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
// ... other imports
```

### Import Order
1. Qt modules (`QtQuick`, `QtQml`)
2. Quickshell modules (`Quickshell`, `Quickshell.Io`, etc.)
3. Custom Quickshell modules (`qs.modules.common`, `qs.services.*`)
4. Project-specific (`qs`)

### Naming Conventions
- **Singletons**: Use `id: root`
- **Properties/functions**: `camelCase` (e.g., `property bool ready`, `function setDefaultSink()`)
- **Components**: `PascalCase` (e.g., `component NotifTimer: Timer { }`)
- **Files**: `PascalCase.qml` (e.g., `Audio.qml`, `Network.qml`)

### Property Declarations
```qml
// Simple property
property bool ready: false

// With type
property string audioTheme: Config.options.sounds.theme

// Readonly
readonly property real hardMaxValue: 2.00

// List property
readonly property list<var> outputDevices: root.devices(true)
```

### Functions
```qml
function friendlyDeviceName(node) {
    return (node.nickname || node.description || Translation.tr("Unknown"));
}

// Arrow functions for filters/maps
function appNodes(isSink) {
    return Pipewire.nodes.values.filter((node) => {
        return root.correctType(node, isSink) && node.isStream
    });
}
```

### Documentation Comments
Use JSDoc-style `/** */` for service/file documentation:
```qml
/**
 * A nice wrapper for default Pipewire audio sink and source.
 */
Singleton { ... }
```

### Error Handling
- Use optional chaining: `sink?.audio.volume ?? 0`
- Check for null/undefined: `if (!obj[keys[i]] || typeof obj[keys[i]] !== "object")`
- Use `JSON.parse` with try/catch for type conversion
- Use timers for debounced file operations

### Component Behavior
Always use `pragma ComponentBehavior: Bound` for reactive bindings in Singletons.

### Signal Declarations
```qml
signal sinkProtectionTriggered(string reason);
```

### Connections
```qml
Connections {
    target: sink?.audio ?? null
    property bool lastReady: false
    function onVolumeChanged() { ... }
}
```

## Code Style - Python

Follow PEP 8 with these conventions:

- **Imports**: Standard library first, then third-party
- **Types**: Use type hints (`def __init__(self, translations_dir: str, ...)`)
- **Docstrings**: Google-style docstrings
- **Classes**: `PascalCase`
- **Functions/variables**: `snake_case`

Example:
```python
class TranslationManager:
    def __init__(self, translations_dir: str, source_dir: str, yes_mode: bool = False):
        """Initialize the translation manager."""
        ...

    def extract_translatable_texts(self) -> Set[str]:
        """Extract translatable texts from source code."""
        ...
```

## Configuration System

- **User config**: `~/.config/quickshell/syrup/config.json`
- **Config loader**: `modules/common/Config.qml`
- **Defaults**: Defined in `Config.qml` via `JsonAdapter`
- **Runtime state**: `GlobalStates.qml` (not persisted)

## Adding New Services

1. Create `services/YourService.qml`:
   - Use `pragma Singleton` at the top
   - Follow the import order above
   - Use `id: root`
   - Implement as `Singleton { ... }`

2. Register in `shell.qml` if needed

3. For configurable options, add defaults in `modules/common/Config.qml`

## Key Modules

- **Config.qml** - JSON-based persistent configuration
- **Appearance.qml** - Material Design 3 theming with wallpaper color extraction
- **GlobalStates.qml** - In-memory runtime UI state
- **Persistent.qml** - Cross-session state persistence
- **Notifications.qml** - Notification daemon with grouping

## Useful Patterns

### Null-safe property access:
```qml
property bool ready: Pipewire.defaultAudioSink?.ready ?? false
```

### Filter and map:
```qml
readonly property list<var> outputDevices: root.devices(true)
function devices(isSink) {
    return Pipewire.nodes.values.filter(node => {
        return root.correctType(node, isSink) && !node.isStream
    });
}
```

### Debounced file operations:
```qml
Timer {
    id: fileWriteTimer
    interval: root.readWriteDelay
    repeat: false
    onTriggered: { configFileView.writeAdapter() }
}
```
