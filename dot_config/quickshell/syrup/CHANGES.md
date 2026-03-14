# Syrup Configuration Changes

This is a customised version of the `ii` (Illogical Impulse) configuration with the following modifications:

## Changes from `ii`

### Configuration Location
- **Changed:** Config file now lives at `~/.config/quickshell/syrup/config.json`
- **Previously:** `~/.config/illogical-impulse/config.json`
- **Why:** Simpler, keeps everything in one place

### Removed Components

#### Panel Families
- **Removed:** Waffle panel family (Windows-inspired UI)
- **Kept:** Illogical Impulse (ii) only
- **Files deleted:**
  - `modules/waffle/` (entire directory)
  - `panelFamilies/WaffleFamily.qml`
- **Savings:** ~120KB

#### Translations (Phase 1)
- **Removed:** All non-English translation files
- **Kept:** `en_US.json`, `tools/`
- **Files deleted:**
  - `de_DE.json` (German)
  - `he_HE.json` (Hebrew)
  - `id_ID.json` (Indonesian)
  - `it_IT.json` (Italian)
  - `ja_JP.json` (Japanese)
  - `pt_BR.json` (Portuguese)
  - `ru_RU.json` (Russian)
  - `tr_TR.json` (Turkish)
  - `uk_UA.json` (Ukrainian)
  - `vi_VN.json` (Vietnamese)
  - `zh_CN.json` (Chinese)
- **Savings:** ~80KB

#### Services (Phase 2)
- **Removed:** Unused keyboard and first-run services
- **Files deleted:**
  - `services/HyprlandXkb.qml` (keyboard layout switching - single layout only)
  - `services/HyprlandKeybinds.qml` (keybind display - user knows keybinds)
  - `services/FirstRunExperience.qml` (first-run tutorial - past first run)
- **Savings:** ~15KB

#### UI Modules (Phase 2)
- **Removed:** Cheatsheet panel (keybind viewer)
- **Files deleted:**
  - `modules/ii/cheatsheet/` (entire directory)
    - `Cheatsheet.qml`
    - `CheatsheetKeybinds.qml`
    - `CheatsheetPeriodicTable.qml`
    - `ElementTile.qml`
    - `periodic_table.js`
- **Savings:** ~5KB

#### Infrastructure Simplification (Phase 2)
- **Simplified:** Panel family switching infrastructure removed
- **Files modified:**
  - `shell.qml` - Removed family list, cycle functions, IpcHandler, GlobalShortcut (~40 lines)
  - `panelFamilies/IllogicalImpulseFamily.qml` - Removed cheatsheet import and loader
  - `config.json` - Now empty object (user settings auto-populated at runtime)
- **Reason:** Only one theme (ii) exists after waffle removal, switching infrastructure unnecessary

### Kept Components (Intentional)

These features are **explicitly kept** despite being optional:

- **AI Subsystem** - Full AI chat integration (Gemini, OpenAI, Mistral)
  - `services/Ai.qml`
  - `services/ai/` (all provider strategies)
  - `services/Translation.qml`
  - `services/LatexRenderer.qml`
  - `scripts/ai/`
  - `defaults/ai/`
  - For future customisation/tweaking

- **SongRec** - Music recognition feature
  - `services/SongRec.qml`
  - `scripts/musicRecognition/`
  - Active feature, not optional

- **Weather** - Weather widget/service
  - `services/Weather.qml`
  - Bar/background weather display

## First Run Setup

1. Run quickshell from the syrup directory:
   ```bash
   cd ~/.config/quickshell/syrup
   quickshell
   ```

2. Config file will be auto-created at:
   ```
   ~/.config/quickshell/syrup/config.json
   ```

3. Or manually create it (empty object is fine):
   ```bash
   echo '{}' > ~/.config/quickshell/syrup/config.json
   ```

   Your settings will be auto-populated at runtime.

## Configuration

Edit `~/.config/quickshell/syrup/config.json` to customise settings.

**Key settings:**
- `appearance.*` - Fonts, colours, transparency
- `bar.*` - Bar position, style, widgets
- `ai.*` - AI chat settings

Note: `panelFamily` removed (only ii theme supported)

See [docs](../docs/syrup/) for full documentation.

## Maintenance Notes

- **AI features:** Kept for future customisation (configure API keys in system keyring)
- **SongRec:** Requires `songrec`, `parec`, `ffmpeg` installed
- **Weather:** Requires API key configuration
- **Translations:** Add back if needed from original `ii` config

## Disk Usage

- Original `ii` config: 5.8M
- Phase 1 (translations + waffle): 4.6M (~21% reduction)
- Phase 2 (services + cheatsheet + simplification): ~4.6M (~22% total reduction)
- Total savings: ~1.2M
- Further reduction possible (see pruning guide)

## Migration from ii

If migrating from `ii`:

1. Copy old config if exists:
   ```bash
   cp ~/.config/illogical-impulse/config.json ~/.config/quickshell/syrup/config.json
   ```

2. Update any paths in scripts that referenced old location

3. Old `~/.config/illogical-impulse/` can be removed after migration

## Further Reading

- [Syrup README](README.md) - Overview
- [Getting Started](../docs/syrup/01-GETTING-STARTED.md) - Setup guide
- [Architecture](../docs/syrup/02-ARCHITECTURE.md) - How it works
- [Services](../docs/syrup/03-SERVICES.md) - Feature catalogue
- [Pruning Guide](../docs/syrup/04-PRUNING-GUIDE.md) - Further minimisation
