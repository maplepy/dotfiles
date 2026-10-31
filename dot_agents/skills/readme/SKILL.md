---
name: readme
description: README generation in maplepy's centered style (loqui, 42-mobile, dotfiles). Use when asked to create, update, or rewrite a README.md.
---

# README

## Steps

1. Read the project (manifest, `Cargo.toml`/`package.json`/`pyproject.toml`, tree, existing README) for name, purpose, stack, install/run commands. Keep only what is true.
2. User gave images? Ask per image: **banner** or **screenshots**.
3. 42 mode when the user says so, the repo is named `42-*`, or a subject file is already in context. Otherwise off; never run a detection step.
4. Fill the skeleton below. Core sections always; menu sections only when the project has the content.
5. Write `README.md` at the root; ask before overwriting an existing one. No AI attribution.

Done when: every core section present, every badge backed by the project, every anchor in the nav matches a section id.

## Skeleton

```html
<div align="center">
    <img src="docs/banner.png" width=55% height=55%>   <!-- banner only -->
    <br><br>
    <h1>• name •</h1>
    <sub>One-line description</sub>
    <br><br>
    <img src="STACK BADGE">
    <img src="STACK BADGE">
    <br>
    <img src="PROJECT BADGE">
    <img src="PROJECT BADGE">
    <br><br>
    <a href="#overview">Overview</a>
    ·
    <a href="#installation">Installation</a>
</div>

<br>

<div align="center">
    <h2 id="overview">• overview •</h2>
</div>

Paragraph with **bold** key terms.

<br>

<div align="center">
    <h2 id="installation">• installation •</h2>
</div>

```bash
# comment
command
```

### Requirements

- dependency
```

- Core: header, **overview**, **installation** (with `### Requirements`), **usage** (when there is something to run), **license** (always last; one line plus link).
- Order: header, overview, screenshots, installation, usage, stack, then project sections (modules, how it works, configuration, documentation, deployed contracts, anything else), license.
- **screenshots**: centered `<img>` row, screenshots only. **stack**: table `| Category | Programs |`, bold category, link every program.
- Section headers: lowercase, `• name •`, `id` = dashed name. `<br>` between sections. Nav links separated by `·` on its own line.

## Badges

Two groups, one `<br>` apart; each group on its own row(s). Versions come from the manifest (`engines`, `requires-python`, `rust-version`, `edition`), never guessed.

1. **Stack** (first): frameworks/tools/services used (Expo, Supabase, Docker...), with version when known.
   `https://img.shields.io/badge/<Name>-<version>-<BRAND>?style=for-the-badge&logo=<slug>&logoColor=D9E0EE&labelColor=1E202B`
2. **Language and version** (second): each language/runtime/package manager with the version the project requires (`Python 3.12`, `Node 18+`, `npm 11`, `Rust 2024`), same URL pattern. Nothing else by default. Add a platform badge only when the project itself restricts platforms (manifest `os`, platform-specific code), never from the machine you are on; add license only when a license file exists; add `https://img.shields.io/github/last-commit/<owner>/<repo>?style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B` or `.../repo-size/...` (`color=86dbce&logo=protondrive`) only when the user asks.

Shields does not auto-brand: pass the hex. Logo slugs are [simple-icons](https://simpleicons.org). Unknown tech: `D9E0EE`.

| Tech | Hex | Tech | Hex | Tech | Hex |
|------|-----|------|-----|------|-----|
| Rust | DEA584 | TypeScript | 3178C6 | JavaScript | F7DF1E |
| Python | 3776AB | Go | 00ADD8 | C | A8B9CC |
| C++ | 00599C | Java | ED8B00 | Lua | 2C2D72 |
| Node.js | 5FA04E | React Native | 61DAFB | Expo | 000020 |
| Svelte | FF3E00 | Vue | 4FC08D | Docker | 2496ED |
| Supabase | 3FCF8E | Solidity | 363636 | Linux | FCC624 |
| Nix | 5277C3 | Bash | 4EAA25 | Git | F05032 |

## 42 mode

Same README, plus one badge first in the first group: `https://img.shields.io/badge/School%20project-000000?style=for-the-badge&logo=42&logoColor=white`. Project name stays the title. Nothing else changes.
