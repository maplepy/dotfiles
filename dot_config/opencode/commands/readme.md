---
description: Generate beautiful README.md in the user's signature style
---

Generate a `README.md` for this project. First explore the project to infer name, description, and stack (check package.json, Cargo.toml, pyproject.toml, Makefile, directory listing, existing README.md, etc.).

If `$ARGUMENTS` is "elaborate" or "compact", use that mode. Otherwise auto-detect:
- **elaborate**: dotfiles, config repos, frameworks, multi-tool projects (3+ tech categories or sub-systems)
- **compact**: single-binary tools, libraries, school projects, narrow-scope (default)

## Style Guide (apply to ALL READMEs)

### Header block
```html
<div align="center">
    <h1>• project name •</h1>
    <sub>One-line description</sub>
    <br><br>
    <img src="https://img.shields.io/badge/..." style=...>
    <img src="https://img.shields.io/badge/..." style=...>
    <br><br>
    <a href="#overview">Overview</a>
    ·
    <a href="#installation">Installation</a>
    ·
    <a href="#usage">Usage</a>
</div>
```

### Badge format
`style=for-the-badge&color=<hex>&logo=<name>&logoColor=<hex>&labelColor=<hex>`
- **color**: primary badge body color — project theme or tech brand color
- **logo**: nounproject logo slug (case-sensitive, e.g. `git`, `kubernetes`, `docker`, `vagrant`)
- **logoColor**: usually `D9E0EE` or white `FFFFFF`
- **labelColor**: dark `1E202B` (or `000000`)

Auto-generate badges for language, framework, build status (`last-commit`, `repo-size`), CI/CD tool, platform, license.

Compact: 2-3 badge rows in `<div align="center">`. Elaborate: 1-2 badge rows in header, then stack table (no badges in table).

### Section headers
```html
<div align="center">
    <h2 id="section-id">• section name •</h2>
</div>
```
Lowercase, dashes for multi-word. No punctuation except `•`.

### Section body
**Elaborate**: paragraph descriptions with bolded terms, tables for stacks (`| Category | Programs |`), code blocks for install, **Requirements** sub-section if deps exist.

**Compact**: badge wall, 1-2 sentence description as blockquote, 1-2 code blocks max, no tables unless genuinely diverse stack.

### Tables (elaborate)
```
| Category | Programs |
|----------|----------|
| **Compositor** | [Hyprland](https://github.com/hyprwm/Hyprland) |
```
Bold category, link every program. Left-align.

### Installation
```bash
# explanation
command --to --install
```
Include `### Requirements` if deps exist.

### Spacing
- `<br>` between major sections, `<br><br>` between sections with no natural transition
- One blank line between markdown block elements
- No trailing whitespace

### Links
In-header nav: middle dot separator — no spaces either side: `·`

## Templates

### Compact
```html
<div align="center">
    <h1>• <name> •</h1>
</div>
<div align="center">
    <img src="https://img.shields.io/badge/..."> <img src="https://img.shields.io/badge/...">
    <br>
    <img src="https://img.shields.io/badge/...">
</div>
> <one-line description>
```

### Elaborate
```html
<div align="center">
    <h1>• <name> •</h1>
    <sub><description></sub>
    <br><br>
    <img src="<badge>"> <img src="<badge>">
    <br><br>
    <a href="#overview">Overview</a> · <a href="#stack">Stack</a> · <a href="#installation">Installation</a>
</div>
<br>
<div align="center"><h2 id="overview">• overview •</h2></div>
<paragraph with **bold** terms>
<br>
<div align="center"><h2 id="stack">• stack •</h2></div>
| Category | Programs |
|----------|----------|
| ... | ... |
<br>
<div align="center"><h2 id="installation">• installation •</h2></div>
```bash
<commands>
```
### Requirements
- <req1>
```

## Output
Write to project root as `README.md`. If one exists, ask before overwriting. Show preview of first ~20 lines. Do NOT add AI attribution.
