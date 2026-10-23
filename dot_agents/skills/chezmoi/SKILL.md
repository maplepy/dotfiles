---
name: chezmoi
description: Manage dotfiles with chezmoi. Use when adding, editing, applying, or diffing dotfiles; changing source-state attributes; writing templates or install scripts; setting up a new machine from a dotfiles repo; or diagnosing why a config file differs from its managed version.
---

# chezmoi

Three states: **source**, **destination** (`~`), **target** (what source renders to). Source changes flow through chezmoi to the destination, never the reverse.

## The one hard rule

Operate only through `chezmoi` commands. Never `cd` into the source directory — `chezmoi cd` included — and never open, read, write, delete, or run `git` there directly, not even to "just fix" a template or a filename. `chezmoi git --` runs in the source tree too, so it is off-limits as well.

Every source change has a verb:

| Intent | Command |
|---|---|
| Edit a managed file | `chezmoi edit <target>` |
| Add or replace a file | `chezmoi add <target> [--template] [--encrypt]` |
| Change attributes/type | `chezmoi chattr ...` |
| Edit config | `chezmoi edit-config` |
| Edit config template | `chezmoi edit-config-template` |

Always name the target: bare `chezmoi edit` opens the source tree and is off-limits.

## Start every task with the same read

```bash
chezmoi status              # first col: changed since apply; second col: apply will change
chezmoi diff <target>       # exact changes apply would make
```

In `status`, first-column `M` means edited outside chezmoi — `chezmoi re-add` captures it. Second-column `M` means apply would overwrite it — capture the wanted change before applying.

## Change a managed file

1. `chezmoi edit <target>` — opens the source file in the editor (decrypts encrypted files, keeps `.tmpl`).
2. `chezmoi cat <target>` — renders the target to check the result.
3. `chezmoi apply <target>` — writes it.

Unmanaged file → `chezmoi add <target>` (`--template`, `--encrypt`, `--exact` for dirs, `--recursive`). Turn an added file into a script with `chezmoi chattr script <target>`.

Change attributes with `chezmoi chattr +private +executable <target>`; `chattr` renames the source file for you, so never do it by hand.

Stop managing (keep the file): `chezmoi forget <target>`. Delete source, destination, and state: `chezmoi destroy <target>`.

## Naming attributes (order matters)

| Target | Prefixes in order | Suffix |
|---|---|---|
| File | `encrypted_`, `private_`, `readonly_`, `empty_`, `executable_`, `dot_` | `.tmpl` |
| Directory | `external_`, `exact_`, `private_`, `readonly_`, `dot_` | — |
| Create | `create_`, then file prefixes | `.tmpl` |
| Modify | `modify_`, then file prefixes | `.tmpl` |
| Script | `run_`, `once_`/`onchange_`, `before_`/`after_` | `.tmpl` |
| Symlink | `symlink_`, `dot_` | `.tmpl` |

`private_` for secrets (`.ssh`, `.gnupg`), `exact_` deletes unmanaged extras in a directory, `external_` stops chezmoi recursing, `literal_`/`.literal` stop attribute parsing.

## Templates

- `.tmpl` files are Go `text/template`; inspect variables with `chezmoi data` (`.chezmoi.os`, `.chezmoi.hostname`, `.chezmoi.arch`, custom `.data.*`).
- Render a real target with `chezmoi cat <target>`; test fragments with `chezmoi execute-template '{{ .chezmoi.os }}'`.
- Machine differences belong in `.chezmoi.toml.tmpl` or `.chezmoidata*`; prompts (`promptStringOnce`) run only during `chezmoi init`.
- `chezmoi apply --dry-run --verbose` renders everything without writing.

### This repo's data vocabulary

`.chezmoi.toml.tmpl` prompts once and emits:

| Key | Values |
|---|---|
| `.data.environment` | `school`, `work`, `personal` |
| `.data.machine_type` | `restricted` (school), `workstation` (work), `laptop`/`desktop`/`server` (personal) |
| `.data.package_management` | bool — gate package installs |
| `.data.gaming`, `.data.dark_mode` | bool |
| `.data.wm` | `none`, `hyprland` |
| `.data.suite` | `none`, `standard`, `quickshell` |
| `.data.osid` | `linux-<os-release id>` |
| `.data.laptop`, `.data.personal` | legacy booleans |

`github_pat`, `zen_path`, `context7_api_key` are emitted as empty strings. Values are fixed once `~/.config/chezmoi/chezmoi.toml` exists; change them with `chezmoi edit-config`, not by editing the template.

## Scripts

`run_once_` for installers (runs once per content hash), `run_onchange_` when the rendered template changes, `before_`/`after_` to order against file updates. Scripts get `CHEZMOI_*` env vars and run in the target directory.

## Externally modified files

Apps that rewrite their own config (Zed, VS Code, browsers) lose changes on the next `apply`. Three patterns, best first. Docs: https://www.chezmoi.io/user-guide/manage-different-types-of-file/#handle-configuration-files-which-are-externally-modified

### Symlink into the source

1. Copy the live file into the source root: `cp ~/.config/zed/settings.json $(chezmoi source-path)/zed-settings.json`
2. Ignore the payload's own target so chezmoi never creates `~/zed-settings.json`: `echo zed-settings.json >> $(chezmoi source-path)/.chezmoiignore`
3. Add a symlink entry `dot_config/zed/symlink_settings.json.tmpl` containing `{{ .chezmoi.sourceDir }}/zed-settings.json` (use `private_` prefixes for private parents).
4. `chezmoi apply` — the app now writes directly into the source file.

- Apps that save via temp-file + rename replace the symlink with a regular file; after the app saves, check `test -L <target>` and fall back to the directory variant below.
- `autoCommit`/`autoPush` only run after chezmoi commands, so direct source writes wait for the next modifying command. Set `git.autoAdd = true` if those writes should be staged too.
- `re-add` ignores symlinks and refuses templates; `add --follow` dereferences a symlink.

### Symlink the directory (atomic-rename writers)

Zed saves settings with `fs.atomic_write` (`NamedTempFile` + `persist`), which replaces a file symlink. Symlink the containing **directory** instead; the rename then happens inside the source dir:

1. `cp -aL ~/.config/zed/. $(chezmoi source-path)/zed-config/` (follow symlinks; `chmod` any private files).
2. `echo zed-config >> $(chezmoi source-path)/.chezmoiignore`.
3. Remove any individual `dot_config/zed/*` source entries, then add `dot_config/symlink_zed.tmpl` containing `{{ .chezmoi.sourceDir }}/zed-config`. Chezmoi refuses a symlink and files at the same target.
4. `chezmoi apply ~/.config/zed` (use `--force` if the directory was removed).

Trade-off: chezmoi manages the directory as one symlink; files inside are plain files in the payload dir, not individual targets. Verify an atomic save survives: `tmp=$(mktemp -p ~/.config/zed); cp ~/.config/zed/settings.json "$tmp"; mv "$tmp" ~/.config/zed/settings.json; test -L ~/.config/zed`.

### Periodic `re-add`

`chezmoi re-add <target>` captures the current destination. It refuses templates and ignores anything that is not a regular file. Timer/cron is opt-in; ask before adding one.

### Partial management

- `modify_` script: stdin = current content, stdout = new content. A first line `{{- /* chezmoi:modify-template */ -}}` turns the rest into a template with `.chezmoi.stdin`; `setValueAtPath` edits JSON/JSONC/TOML/YAML. Modify templates must not end in `.tmpl`.
- `create_` plus `private_`/`executable_`/`readonly_` creates the file if missing and enforces permissions without touching content.

## Secrets

`chezmoi cat` prints decrypted content, so avoid it on secret files in shared logs. `chezmoi add --encrypt` stores age-encrypted; `chezmoi edit` transparently decrypts and re-encrypts. Password managers go through `secret`/`secretJSON`. Settle for a plaintext template only if the value is not actually secret.

## Safety

- `chezmoi add` copies the destination over the source; run `chezmoi diff` first or you lose newer template content.
- `apply` on a file changed since the last write prompts for a reason; prefer `chezmoi merge <target>` to reconcile instead of overwriting.
- `exact_`, `destroy`, `purge` are destructive: list targets before running.
- This machine sets `git.autoPush = true`, so `add`, `edit`, and `chattr` commit and push immediately. Confirm before changing the source; there is no per-command opt-out.

## Diagnose

```bash
chezmoi doctor
chezmoi verify                    # exit 1 if any target differs
chezmoi managed | unmanaged | ignored
chezmoi dump <target>             # target state as data
chezmoi state dump                # script hashes, last-written times
```

Template error → `chezmoi execute-template < file.tmpl`. Conflict → `chezmoi merge`. Drift → `chezmoi re-add` or reapply.

The installed binary is the authority for syntax: `chezmoi --help`, `chezmoi help <command>`. Full attribute and template-function reference: https://www.chezmoi.io/reference/.
