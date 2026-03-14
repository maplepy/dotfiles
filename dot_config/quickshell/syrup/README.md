# Syrup Configuration

A minimalist, single-theme Quickshell configuration based on Illogical Impulse (ii) with 35+ services.

## Quick Start

```bash
# Syrup auto-creates config on first run
cd ~/.config/quickshell/syrup
quickshell
```

## What is Syrup?

Syrup is a streamlined fork of ii with:

- **Single panel family**: Illogical Impulse only (feature-rich, customisable)
- **35+ services**: notifications, audio, network, battery, media controls, AI chat, weather, wallpapers, updates, and more
- **Modular architecture**: swap or remove features without breaking core functionality
- **Persistent configuration**: JSON-based config with live reload support
- **Theming system**: Material Design 3 with wallpaper-based colour extraction

## Architecture Overview

```
syrup/
├── shell.qml              # Entry point, loads services and ii panel family
├── GlobalStates.qml       # Runtime UI state (panel visibility, locks, etc.)
├── modules/
│   ├── common/            # Shared infrastructure (Config, Appearance, widgets)
│   ├── ii/                # Illogical Impulse panel family (19 panels)
│   └── settings/          # Settings UI pages
├── services/              # 35+ feature singletons (Notifications, Audio, etc.)
├── panelFamilies/         # Panel family loaders
├── scripts/               # External shell scripts (colours, Hyprland, etc.)
└── translations/          # i18n support (English only)
```

**Key concepts:**

- **Panel family** - Illogical Impulse loads directly (no switching infrastructure)
- **Services** are singletons providing features (e.g., `Notifications.qml`, `Audio.qml`)
- **Common modules** provide shared widgets, utilities, and configuration
- **Config + GlobalStates** manage persistent settings and runtime state

## Illogical Impulse Panel Family

Feature-rich, customisable desktop environment with:

- Top/bottom bar with extensive configuration
- Dual sidebars (left: AI chat, wallpapers, search | right: widgets, todo, timer)
- App dock with icon support
- Overview/search launcher
- Media controls overlay
- Lock screen with wallpaper preview
- On-screen keyboard and display notifications
- Screen corner actions
- Region selector for screenshots
- Session management screen

**Best for:** Power users wanting maximum features and customisation.

## Configuration Flow

```
┌─ Persistent Storage ───────────────────────────────┐
│ ~/.config/quickshell/syrup/config.json             │
│ ~/.local/state/quickshell/                         │
└──────────────────────────────────────────────────────┘
                    ↓
┌─ Config Layer (Config.qml) ────────────────────────┐
│ - Loads JSON config with watchers                  │
│ - Provides Config.options.* bindings               │
│ - Auto-saves changes                               │
└──────────────────────────────────────────────────────┘
                    ↓
┌─ Runtime State (GlobalStates.qml) ─────────────────┐
│ - In-memory UI state (not persisted)               │
│ - Panel visibility, locks, focus state             │
└──────────────────────────────────────────────────────┘
                    ↓
┌─ UI Consumers ──────────────────────────────────────┐
│ Panels, services, widgets read Config + GlobalStates│
└──────────────────────────────────────────────────────┘
```

## Essential Services

**Always loaded:**

- `Config.qml` - Configuration management
- `Appearance.qml` - Theming and Material Design colours
- `Persistent.qml` - State persistence across sessions
- `Notifications.qml` - Notification daemon
- `HyprlandData.qml` - Workspace and window tracking

**Commonly used:**

- `Audio.qml` - Volume control and output management
- `Battery.qml` - Battery status and power management
- `Network.qml` - Network connectivity status
- `Brightness.qml` - Screen brightness control
- `MprisController.qml` - Media player control
- `LauncherApps.qml` / `LauncherSearch.qml` - App launcher
- `Wallpapers.qml` - Wallpaper management
- `DateTime.qml` - Clock and date formatting

**Optional/niche:**

- `Ai.qml` - AI chat integration (Gemini, OpenAI, Mistral)
- `Weather.qml` - Weather API integration
- `SongRec.qml` - Music recognition
- `Booru.qml` - Image board integration
- `Todo.qml` / `TimerService.qml` - Productivity widgets

See [Services Reference](../docs/ii/03-SERVICES.md) for complete catalogue.

## Minimalisation

For a lighter setup, use staged pruning based on service tiers in [Services Reference](../docs/ii/03-SERVICES.md).

**Low-risk reductions (~30%):**

- Remove non-English translations
- Remove niche services (SongRec, Weather, Booru)
- Clean up unused scripts

**Medium-risk (~50%):**

- Consolidate to one panel family
- Remove AI subsystem if unused
- Prune sidebar features

**High-risk (~70%):**

- Strip to minimal panel set (bar + notifications + lock only)
- Remove optional widgets and overlays

## Documentation

- [Requirements](../docs/ii/00-REQUIREMENTS.md) - Packages, fonts, services, and first-run checks
- [Getting Started](../docs/ii/01-GETTING-STARTED.md) - Setup, testing, and first customisation
- [Architecture](../docs/ii/02-ARCHITECTURE.md) - Detailed component map and startup flow
- [Services](../docs/ii/03-SERVICES.md) - Complete service reference with tiers

## Key Files to Read

1. `shell.qml` - Entry point and panel family loading
2. `GlobalStates.qml` - UI state management
3. `modules/common/Config.qml` - Configuration system
4. `panelFamilies/PanelLoader.qml` - Lazy loading pattern
5. `modules/common/Appearance.qml` - Theming system

## Contributing / Customisation

- Modify `Config.qml` defaults to change initial settings
- Add services in `services/` following existing patterns
- Create custom panel families in `panelFamilies/`
- Extend widgets in `modules/common/widgets/`

## Troubleshooting

**Config not loading:** Check `~/.config/illogical-impulse/config.json` exists and contains valid JSON.

**Panel family not switching:** Restart quickshell after editing config file.

**Services failing:** Run `quickshell -vv` for verbose logging.

**Missing keybinds:** Check Hyprland config has quickshell shortcuts defined.

## License & Credits

Part of the Illogical Impulse Quickshell configuration. See individual files for licensing details.
