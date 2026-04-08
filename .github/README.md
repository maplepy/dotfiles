<div align="center">
    <img src="../images/safe-heaven.png" width=55% height=55%>
    <br><br>
    <h1>maplepy's safe heaven</h1>
    <sub>A personal, environment-aware dotfiles setup built with chezmoi</sub>
    <br><br>
    <img src="https://img.shields.io/github/last-commit/maplepy/dotfiles?style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B">
    <img src="https://img.shields.io/github/repo-size/maplepy/dotfiles?style=for-the-badge&color=86dbce&logo=protondrive&logoColor=D9E0EE&labelColor=1E202B">
    <br><br>
    <a href="#overview">Overview</a>
    ·
    <a href="#stack">Stack</a>
    ·
    <a href="#how-it-works">How it works</a>
    ·
    <a href="#installation">Installation</a>
</div>

<br>

<div align="center">
    <h2 id="overview">• overview •</h2>
</div>

These are my personal dotfiles, managed with [chezmoi](https://github.com/Tuxdude/chezmoi). The setup is designed to be **environment-aware** — it adapts based on whether you're on a personal machine, at work, or at school.

Two desktop suites are supported:

- **Standard** — The classic Hyprland stack: [Waybar](https://github.com/Alexays/Waybar) for the bar, [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) for notifications, [Wlogout](https://github.com/ArtsyMacaw/wlogout) for the power menu, [Dunst](https://github.com/dunst-project/dunst) as an alternative notification daemon, and [Rofi](https://github.com/davatorium/rofi) as the launcher.
- **Quickshell** — A single [Quickshell](https://github.com/quickshell) instance that replaces waybar, swaync, wlogout, and more with a unified, scriptable shell. Choose this if you want one cohesive panel instead of separate programs.

<br>

<div align="center">
    <h2 id="stack">• stack •</h2>
</div>

| Category | Programs |
|----------|----------|
| **Compositor** | [Hyprland](https://github.com/hyprwm/Hyprland) |
| **Shell** | [Fish](https://github.com/fish-shell/fish-shell) |
| **Terminal** | [Kitty](https://github.com/kovidgoyal/kitty), [Alacritty](https://github.com/alacritty/alacritty) |
| **Editor** | [Neovim](https://github.com/neovim/neovim), [Zed](https://github.com/zed-industries/zed) |
| **Bar** | [Waybar](https://github.com/Alexays/Waybar), [Quickshell](https://github.com/quickshell) |
| **Notifications** | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter), [Dunst](https://github.com/dunst-project/dunst) |
| **Launcher** | [Rofi](https://github.com/davatorium/rofi), [Albert](https://github.com/albertlauncher/albert) |
| **Logout** | [Wlogout](https://github.com/ArtsyMacaw/wlogout) |
| **Theming** | [Matugen](https://github.com/InioX/matugen) |
| **File Manager** | [Yazi](https://github.com/sxyazi/yazi) |
| **Music** | [MPD](https://www.musicpd.org/) |
| **Package Manager** | [Paru](https://github.com/Morganamilo/paru) |
| **Other** | [yt-dlp](https://github.com/yt-dlp/yt-dlp), [EasyEffects](https://github.com/wwmm/easyeffects), [FreeTube](https://github.com/FreeTubeApp/FreeTube) |

<br>

<div align="center">
    <h2 id="how-it-works">• how it works •</h2>
</div>

The setup uses **chezmoi templates** to prompt for your environment on first run and generate a tailored configuration:

1. **Environment** — Choose between `personal`, `work`, or `school`. Each restricts or enables different configs.
2. **Machine type** — For personal setups: `laptop`, `desktop`, or `server`.
3. **Desktop suite** — Pick your UI stack: `standard` (waybar + swaync + wlogout), `quickshell`, or `none`.
4. **Window manager** — Currently `hyprland`.
5. **Gaming** — Optional gaming extras (MangoHud, gamemode, etc).

All of this is driven by [`.chezmoi.toml.tmpl`](.chezmoi.toml.tmpl) and [`.chezmoiignore.tmpl`](.chezmoiignore.tmpl). Legacy WM configs (bspwm, qtile, polybar, sxhkd) are archived on the `archive/legacy-wm-configs` branch.

<br>

<div align="center">
    <h2 id="installation">• installation •</h2>
</div>

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Apply dotfiles (will prompt for environment on first run)
chezmoi init --apply maplepy/dotfiles
```

Or clone and apply manually:

```bash
chezmoi init --apply https://github.com/maplepy/dotfiles.git
```

### Requirements

- Arch Linux (or Arch-based distro)
- chezmoi
- Hyprland (for the standard/quickshell suites)

<br>
