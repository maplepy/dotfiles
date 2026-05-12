---
name: readme
description: >
  Generate beautiful, visually-rich README.md files in the user's signature style:
  centered layouts with <div align="center">, badge bars, "• section •" headers,
  tech stack tables, and clean installation sections. Two modes: elaborate
  (multi-section with feature descriptions + tables) and compact (badge-heavy
  quick-reference). Use when user says "generate a readme", "create readme",
  "write readme", "make readme pretty", or "/readme".
---

# README Generator

Generate README.md in the user's visual style. Two output modes depending on project scope.

## Mode Detection

| Project type | Mode | Example |
|---|---|---|
| dotfiles, config repos, frameworks, tools with many sub-commands | **elaborate** | dotfiles README with feature desc + stack table + install guide |
| school projects, single-binary tools, libraries, narrow-scope projects | **compact** | Inception-of-Things README with badge wall + one-liner |

Default: **compact**. Escalate to **elaborate** if project has 3+ categories of tech or multiple sub-systems.

## Workflow

### 1. Explore the project

Read these (in priority order) to infer name, description, stack:

- Existing `README.md` (if regenerating — ask user first)
- `package.json` — `name`, `description`, `dependencies`
- `Cargo.toml` — `package.name`, `package.description`
- `pyproject.toml` — `project.name`, `project.description`
- `Makefile` — look for `PACKAGE`, `NAME`
- Directory listing — file extensions reveal stack
- `.gitignore`, `Dockerfile`, `compose.yaml` — infra hints
- Any `*.md` files in root — project docs

If project has a clear single purpose, use compact. If it's a multi-tool or config ecosystem, use elaborate.

### 2. Draft README

Both modes share these style rules.

---

## Style Guide (apply to ALL READMEs)

### Header block

```html
<div align="center">
    <h1>• project name •</h1>
    <sub>One-line description of what this does</sub>
    <br><br>
    <!-- badge row(s) -->
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

Distance from dotfiles example: use `<img>` with `width=55% height=55%` before `<h1>` if user supplies a project image path. Include `<br><br>` between elements for breathing room.

### Badge format

```
style=for-the-badge&color=<hex>&logo=<name>&logoColor=<hex>&labelColor=<hex>
```

- **color**: primary color for the badge body — pick from project theme or tech brand color
- **logo**: nounproject logo slug (case-sensitive, e.g. `git`, `kubernetes`, `docker`, `vagrant`)
- **logoColor**: usually `D9E0EE` or white `FFFFFF`
- **labelColor**: dark `1E202B` for contrast (or `000000`)

Badge types to auto-generate:
| What | Badge label | Example |
|------|-------------|---------|
| Language | `<lang>` | `Python` |
| Framework | `<framework>` | `React` |
| Build status | `last-commit`, `repo-size` | `https://img.shields.io/github/last-commit/<user>/<repo>` |
| CI/CD | `<tool>` | `Argo CD` |
| Platform | `<name>` | `Vagrant`, `Kubernetes`, `Docker` |
| License | `license` | `MIT` |

For compact mode: pack as many badges as fit in 2-3 rows using `<div align="center">`.

For elaborate mode: 1-2 badge rows in header, then stack table with program names (no badges in table).

### Section headers

```html
<div align="center">
    <h2 id="section-id">• section name •</h2>
</div>
```

Lowercase, no punctuation except the `•` bullets. Dashes for multi-word: `how-it-works`.

### Section body

**Elaborate** uses:
- Paragraph descriptions with bolded terms
- Tables for stacks: `| Category | Programs |` with links e.g. `[Fish](https://github.com/fish-shell/fish-shell)`
- Code blocks for installation commands
- **Requirements** sub-section if dependencies exist

**Compact** uses:
- Badge wall (stack at a glance)
- 1-2 sentence description as blockquote
- Minimal code blocks (1-2 commands max)
- No tables unless project has genuinely diverse stack

### Tables (elaborate mode)

```
| Category | Programs |
|----------|----------|
| **Compositor** | [Hyprland](https://github.com/hyprwm/Hyprland) |
| **Shell** | [Fish](https://github.com/fish-shell/fish-shell) |
```

Bold the category name, link every program. Left-align both columns.

### Installation blocks

```bash
# One-liner explanation
command --to --install

# Or multi-step
git clone <url>
cd <project>
make install
```

Include a "### Requirements" sub-section if the project has dependencies.

### Spacing

- `<br>` between major sections
- `<br><br>` between sections with no natural text transition
- One blank line between markdown block elements
- No trailing whitespace on any line

### Links

In-header nav links use `·` (middle dot) separator — no spaces on either side:
```
<a href="#section">Section</a> · <a href="#other">Other</a>
```

---

## Template: Compact Mode

```html
<div align="center">
    <h1>• <name> •</h1>
</div>

<!-- badge rows -->
<div align="center">
    <img src="https://img.shields.io/badge/...">
    <img src="https://img.shields.io/badge/...">
    <br>
    <img src="https://img.shields.io/badge/...">
</div>

> <one-line description>

<optional: 1-2 code blocks for quick start>
```

---

## Template: Elaborate Mode

```html
<div align="center">
    <img src="<image-path>" width=55% height=55%>
    <br><br>
    <h1>• <name> •</h1>
    <sub><description></sub>
    <br><br>
    <img src="<badge>">
    <img src="<badge>">
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

<paragraph description with **bold** terms>

<br>

<div align="center">
    <h2 id="stack">• stack •</h2>
</div>

| Category | Programs |
|----------|----------|
| ... | ... |

<br>

<div align="center">
    <h2 id="installation">• installation •</h2>
</div>

```bash
<commands>
```

### Requirements

- <req1>
- <req2>
```

---

## Output

Write the generated README to the project root as `README.md`. If one already exists, ask before overwriting. Show a preview of the first ~20 lines.

Do NOT add "Generated by opencode" or any AI attribution in the README content itself.
