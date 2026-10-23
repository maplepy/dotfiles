---
name: chezmoi
description: Manage dotfiles with chezmoi. Use when adding, editing, applying, or diffing dotfiles; changing source-state attributes or target types; writing templates, template functions, scripts, hooks, or externals; handling secrets, encryption, or password managers; managing machine-to-machine differences; capturing files rewritten by GUI apps; setting up or restoring a machine from a dotfiles repo; or diagnosing why a config file differs from its managed version.
---

# chezmoi

Three states: **source** (`~/.local/share/chezmoi`), **destination** (`~`), **target** (what source renders to). Source changes flow through chezmoi to the destination, never the reverse.

## The one hard rule

Operate through `chezmoi` commands for target entries. Never `cd` into the source directory — `chezmoi cd` included — and never open, write, delete, or run `git` there directly, not even to "just fix" a template or filename. `chezmoi git --` runs in the source tree too, so it is off-limits.

Source-only metadata has no target and therefore no `chezmoi add` verb: `.chezmoiignore`, `.chezmoiremove`, `.chezmoiroot`, `.chezmoiversion`, `.chezmoidata*`, `.chezmoitemplates/`, `.chezmoiscripts/`, external payloads, and the symlink payload recipes below. Create those in `$(chezmoi source-path)` deliberately; that is the only direct-write exception.

Every target change has a verb:

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
chezmoi status              # first col: changed since chezmoi wrote it; second: apply will change it
chezmoi diff <target>       # exact changes apply would make
chezmoi verify              # exit 1 if anything differs; use in CI
```

In `status`, first-column `M` means edited outside chezmoi — `chezmoi re-add` captures it. Second-column `M` means apply would overwrite it — capture the wanted change first. Run `chezmoi doctor` when something unexpected happens.

## Command map

| Command | What it does |
|---|---|
| `add` (`manage`) | Add targets to source; replaces existing source entries. |
| `age`, `age-keygen` | Passphrase age helpers; generate an identity or derive its recipient. |
| `apply` | Make destination match target; prompts if a file changed since chezmoi wrote it. |
| `archive` | Write the target state as tar/zip. |
| `cat` | Print target contents of files, scripts, or symlinks. |
| `cat-config` | Print the merged config. |
| `cd` | Shell in the source tree (off-limits per the hard rule). |
| `chattr` | Change attributes or target type. |
| `completion` | Generate bash/fish/powershell/zsh completion. |
| `data` | Print computed template data. |
| `decrypt`, `encrypt` | Filter stdin/files through configured encryption. |
| `destroy` | Remove target from source, destination, and state. |
| `diff` | Show target vs destination. |
| `docker` (`podman`) | Experimental: run chezmoi in a container. |
| `doctor` | Check for potential problems. |
| `dump` | Dump target state as JSON/YAML. |
| `dump-config` | Dump the config. |
| `edit` | Edit source of a target; decrypts/keeps `.tmpl`. |
| `edit-config`, `edit-config-template` | Edit config or its init template. |
| `edit-encrypted` | Edit ciphertext source directly. |
| `execute-template` | Execute a template literal or file. |
| `forget` (`unmanage`) | Stop managing; keep the destination file. |
| `generate` | Generate `git-commit-message`, `install.sh`, `install-init-shell.sh`. |
| `git` | Run git in the working tree (off-limits). |
| `help`, `license` | Help / license. |
| `ignored` | List targets ignored by `.chezmoiignore`. |
| `import` | Import an archive into the source state. |
| `init` | Clone/setup source, render config template, optionally apply. |
| `managed` (`list`) | List managed entries. |
| `merge`, `merge-all` | Three-way merge destination/target/source. |
| `purge` | Remove config, state, and source; leave targets. |
| `push` | `git add` + commit + push in the source. |
| `re-add` | Recapture modified destination files into source. |
| `remove`, `rm` | Removed commands; use `forget` or `destroy`. |
| `secret` | `secret keyring get/set/delete`. |
| `source-path`, `target-path` | Print source or target paths. |
| `ssh` | Experimental: install and init over SSH. |
| `state` | Inspect/manipulate persistent state. |
| `status` | Git-style status of managed files/scripts. |
| `unmanaged` | List unmanaged files. |
| `update` | Pull (`git pull --autostash --rebase`) then apply. |
| `upgrade` | Install the latest chezmoi release. |
| `verify` | Check target state; exit 0/1. |

Flags worth knowing:

| Command | Flags |
|---|---|
| `add` | `-T/--template`, `-a/--autotemplate`, `--encrypt`, `--create`, `--exact`, `--follow`, `--new`, `--template-symlinks`, `--secrets=ignore\|warning\|error`, `-f/--force`, `-r` |
| `apply` | `-n/--dry-run`, `-v/--verbose`, `--force`, `--interactive`, `--init`, `--source-path`, `-R/--refresh-externals`, `--skip-secrets`, `-i/-x` |
| `chattr` | `+attr`, `-attr`, `noattr`, comma-separated; type modifiers `create`, `modify`, `script`, `symlink` |
| `re-add` | `--re-encrypt`, `-r`, `-i/-x` |
| `init` | `-a/--apply`, `--one-shot`, `--prompt`, `--promptString k=v`, `--promptDefaults`, `--purge`, `--purge-binary` |
| `update` | `--apply=false`, `--recurse-submodules=false`, `--init` |
| `edit` | `-a/--apply`, `--watch`, `--hardlink` |
| `status` | `--path-style=relative\|absolute\|source-absolute\|source-relative\|all`, `--tree` |
| `diff` | `--reverse`, `--script-contents`, `--pager` |
| `destroy` | `--force`, `-r` |
| Global | `-S/--source`, `-D/--destination`, `-c/--config`, `--mode=file\|symlink`, `--no-tty`, `-k/--keep-going`, `--debug` |

`--include`/`--exclude` take `all`, `none`, `dirs`, `files`, `remove`, `scripts`, `symlinks`, `always`, `encrypted`, `externals`, `templates`, optionally `no`-prefixed.

## Capture, edit, remove

- `add --template` stores `.tmpl`; `--autotemplate` replaces values from `[data]` with template expressions, greedily — review the result. `--encrypt` stores ciphertext; `--create` sets `create_`; `--exact` sets `exact_`; `--follow` adds a symlink's target instead of the link.
- `add` replaces the source entry with the destination content. It refuses to overwrite a template unless `--force` is passed. Run `chezmoi diff` first.
- `re-add` recaptures destination content, preserves `encrypted_`, refuses templates, ignores symlinks and externals, and recurses into directories by default. Target one file when that is all that changed.
- `forget` drops source ownership and keeps the file. `destroy` deletes source and destination. `purge` is the whole-config reset.
- `chattr` renames the source for you: `chezmoi chattr private,template ~/.netrc`, `chezmoi chattr script ~/.local/bin/foo`, `chezmoi chattr -- -empty ~/.profile`. Abbreviations: `a` after, `b` before, `e` empty, `x` executable, `o` once, `p` private, `r` readonly, `t` template. Negative type forms (`nocreate`, `nomodify`, `noscript`, `nosymlink`) revert to a regular file.
- `edit --watch` watches the source and applies on save; it needs targets, does not watch `.chezmoitemplates`/`include` files, and requires `edit.hardlink`.

## Source-state attributes

| Target type | Prefixes, in order | Suffixes |
|---|---|---|
| Directory | `remove_`, `external_`, `exact_`, `private_`, `readonly_`, `dot_` | — |
| Regular file | `encrypted_`, `private_`, `readonly_`, `empty_`, `executable_`, `dot_` | `.tmpl` |
| Create file | `create_`, then regular-file prefixes | `.tmpl` |
| Modify file | `modify_`, then regular-file prefixes | `.tmpl` |
| Remove file | `remove_`, `dot_` | — |
| Script | `run_`, `once_` or `onchange_`, `before_` or `after_` | `.tmpl` |
| Symlink | `symlink_`, `dot_` | `.tmpl` |

- `literal_` and `.literal` may appear anywhere and stop attribute parsing.
- `dot_` prepends a dot to the target name; `empty_` keeps an empty file instead of deleting it.
- Encrypted files also carry `.age` (age) or `.asc` (gpg); override with `age.suffix` / `gpg.suffix`.
- Source files/dirs beginning with `.` are ignored except `.chezmoi*`.
- `private_` clears group/world bits; `readonly_` clears write bits; `executable_` sets exec bits.
- `exact_` deletes anything in the target directory not present in source; it is stateful and destructive.
- `external_` stops chezmoi recursing into a directory.

## Target types

- **File** — regular source file. Empty rendered content deletes the target unless `empty_`.
- **Create** — create with contents only if missing; existing contents are untouched, but `private_`/`executable_`/`readonly_` are still enforced. With an empty source file this manages permissions only.
- **Modify** — script: stdin is current content, stdout is new content. If the script contains `chezmoi:modify-template`, those lines are removed and the rest is a template with `.chezmoi.stdin`; use `setValueAtPath`, `replaceAllRegex`, etc. Modify templates must not end in `.tmpl`.
- **Remove** — `remove_` removes the entry if it exists; directories only if empty.
- **Directory** — source directory. `exact_` removes extras; `private_`/`readonly_` adjust modes.
- **Symlink** — source file contains the link target; trailing newline stripped; empty target removes the link.
- **Script** — `run_` executes on every apply; `once_`/`onchange_` gate execution; `before_`/`after_` order against file updates.
- **Symlink mode** — global `mode = "symlink"` turns regular, non-encrypted/executable/private/template targets into links back to source. `add` does not convert until `apply`. Directories and templated/encrypted/private/executable files cannot use it.

## Application order

1. Read source, destination, compute target.
2. Run `run_before_` scripts in alphabetical order.
3. Update entries in ASCII target-name order after attributes are stripped; directories before their contents.
4. Run `run_after_` scripts in alphabetical order.

Source and destination must not change during `apply`; calling `chezmoi re-add` from a script is undefined (and can deadlock the state lock). Externals update during step 3, so `run_before_` scripts must not depend on them.

## Special files and directories

| Entry | Purpose |
|---|---|
| `.chezmoiignore` | Doublestar patterns matched against **target** paths; `!` re-includes; `#` comments; always templated; subdirectory copies apply locally. Not `.gitignore`. |
| `.chezmoiremove` | Patterns of targets to delete; templated; `!` and ignored targets are never removed. Dry-run first. |
| `.chezmoiroot` | Move the source-state root to a relative subdirectory; move other root files (config template, root `.chezmoiignore`) with it. |
| `.chezmoiversion` | Minimum chezmoi version, e.g. `2.50.0`. |
| `.chezmoidata.$FORMAT`, `.chezmoidata/` | Static data merged into the root data dictionary in lexical file order; available as `.key`. |
| `.chezmoiexternal.$FORMAT`, `.chezmoiexternals/` | External files/archives/repos. `.chezmoiexternals/` does not support nested externals. |
| `.chezmoitemplates/` | Named partials: `{{ template "name" . }}` or `includeTemplate`; context is nil unless passed. |
| `.chezmoiscripts/` | `run_` scripts executed without creating a target directory. |
| `.chezmoi.$FORMAT.tmpl` | Config template rendered by `init`/`--init`; sees existing `[data]` and init functions, not `.chezmoidata` or `.chezmoitemplates`. |

## Config sections worth knowing

| Section | Keys |
|---|---|
| Top level | `sourceDir`, `destDir`, `cacheDir`, `persistentState`, `encryption`, `mode`, `umask`, `scriptEnv`, `scriptTempDir`, `tempDir`, `workingTree`, `interactive`, `progress`, `color`, `pager`, `data` |
| `add` | `encrypt`, `secrets`, `templateSymlinks` |
| `age` / `gpg` | `identity`/`identities`, `recipient`/`recipients`, `symmetric`, `passphrase`, `suffix`, `args` |
| `git` | `autoAdd`, `autoCommit`, `autoPush`, `command`, `commitMessageTemplate`, `commitMessageTemplateFile`, `lfs` |
| `edit` | `command`, `args`, `apply`, `watch`, `hardlink`, `minDuration` |
| `diff` | `command`, `args`, `pager`, `reverse`, `scriptContents`, `exclude` |
| `status` | `exclude`, `pathStyle` |
| `update` | `command`, `args`, `apply`, `recurseSubmodules` |
| `merge` | `command`, `args` |
| `hooks` | `<event>.pre` / `<event>.post`, each `command`+`args` or `script` |
| `interpreters` | `<extension>` → `command` + `args` (Windows and non-native scripts) |
| `textconv` | `pattern`, `command`, `args` — transform before diff |
| `pinentry` | `command`, `args`, `options` |
| `warnings` | `configFileTemplateHasChanged` |
| `secret` | `command`, `args` — powers `secret`/`secretJSON` |
| `verify` | `exclude` |
| `completion` | `custom` |
| `cd` | `command`, `args` |
| `template` | `options` (default `["missingkey=error"]`) |
| `docker` | `command` (also used by `podman`) |

Hooks run before/after any command and **even under `--dry-run`**; they receive `CHEZMOI=1` and `CHEZMOI_*`, so they must be fast and idempotent. `git.autoCommit`/`autoPush` fire only after source-modifying commands, not after `apply`, `init`, `update`, or external writes. `umask` controls created modes; `scriptEnv` adds env vars to scripts, hooks, and commands.

## Templates

Go `text/template` plus sprig. `missingkey=error` is the default; override with `[template] options = ["missingkey=zero"]` or a per-file directive:

```gotemplate
{{/* chezmoi:template:missing-key=zero left-delimiter="<<" right-delimiter=">>" */}}
```

- Empty rendered output deletes the file unless `empty_`. `abortEmpty` stops template execution and yields empty output, so it deletes too unless `empty_`.
- `chezmoi cat <target>` renders one target; `chezmoi execute-template '{{ .chezmoi.os }}'` tests fragments; `-f` treats args as files; `--with-stdin` populates `.chezmoi.stdin`.
- `chezmoi data` prints all data. `chezmoi dump` shows target state.
- Directives cover `missing-key`, delimiters, `line-endings`, `encoding`, and `format-indent`.

Key variables: `.chezmoi.os`, `.arch`, `.hostname`, `.fqdnHostname`, `.username`, `.homeDir`, `.sourceDir`, `.destDir`, `.cacheDir`, `.configFile`, `.sourceFile`, `.targetFile`, `.workingTree`, `.version.*`, `.osRelease.*` (Linux), `.kernel.*` (Linux), `.windowsVersion.*`. Custom values live in `.data` or at the data root.

Init functions (config template only): `promptString`, `promptStringOnce`, `promptBool`, `promptBoolOnce`, `promptInt`, `promptIntOnce`, `promptChoice`, `promptChoiceOnce`, `promptMultichoice`, `promptMultichoiceOnce`, `exit`, `writeToStdout`. `promptStringOnce` reads `map[path]`; persistence comes from writing the value into `[data]` in `.chezmoi.toml.tmpl`. A new machine re-prompts unless `init --promptString k=v`, `--promptDefaults`, or pre-seeded data.

General functions by job:

| Job | Functions |
|---|---|
| Files | `include` (literal), `includeTemplate` (executes), `glob`, `globCaseInsensitive`, `joinPath`, `lookPath`, `findExecutable`, `findOneExecutable`, `isExecutable`, `stat`, `lstat` |
| Commands | `exec` (bool, output discarded), `output`, `outputList` (stdout; error aborts), `getRedirectedURL` |
| Data | `fromJson`, `fromJsonc`, `fromToml`, `fromYaml`, `fromIni`, `toJson`, `toPrettyJson`, `toToml`, `toYaml`, `toIni`, `jq`, `setValueAtPath`, `deleteValueAtPath`, `pruneEmptyDicts`, `toString`, `toStrings` |
| Strings | `abortEmpty`, `comment`, `ensureLinePrefix`, `eqFold`, `hexEncode`, `hexDecode`, `quoteList`, `replaceAllRegex`, `shellQuote`, `shellQuoteList` |
| Crypto | `encrypt`, `decrypt` |
| Misc | `debugf`, `warnf`, `stdinIsATTY`, `completion`, `ioreg`, `mozillaInstallHash` |

Password-manager functions (all cached per run): `onepassword`, `onepasswordRead`, `onepasswordDetailsFields`, `onepasswordItemFields`, `onepasswordDocument`; `bitwarden`, `bitwardenFields`, `bitwardenAttachment`, `bitwardenAttachmentByRef`, `bitwardenSecrets`, `rbw`, `rbwFields`; `pass`, `passRaw`, `passFields`; `gopass`, `gopassCat`, `gopassRaw`; `keepassxc`, `keepassxcAttribute`, `keepassxcAttachment`; `keeper`, `keeperDataFields`, `keeperFindPassword`; `lastpass`, `lastpassRaw`; `vault`; `dashlanePassword`, `dashlaneNote`; `doppler`, `dopplerProjectJson`; `awsSecretsManager`, `awsSecretsManagerRaw`; `azureKeyVault`; `ejsonDecrypt`, `ejsonDecryptWithKey`; `passhole`; `protonPass`, `protonPassJSON`, `protonPassAttachment`; `keyring`; generic `secret`, `secretJSON`.

GitHub functions: `gitHubKeys`, `gitHubLatestRelease`, `gitHubLatestReleaseAssetURL`, `gitHubLatestTag`, `gitHubRelease`, `gitHubReleaseAssetURL`, `gitHubReleases`, `gitHubTags`.

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

- `run_` every apply; `run_once_` once per content hash; `run_onchange_` when the rendered template changes.
- `before_`/`after_` order against file updates; otherwise scripts run in ASCII target order. `.chezmoiscripts/` keeps them out of `~`.
- Working directory is the target's first existing parent; `CHEZMOI=1` and `CHEZMOI_*` are set; add extras with `scriptEnv`.
- `run_once_`/`run_onchange_` history lives in the state DB: `chezmoi state delete-bucket --bucket=scriptState` / `entryState` forces re-run.
- Scripts do not run in `--dry-run`; hooks do. To react to another file's content, embed it in a `run_onchange_` template comment.
- `run_onchange_install-packages.sh` is the declarative package-install pattern.

## Externals

`.chezmoiexternal.$FORMAT` (templated) maps target path → external. Types:

| Type | Result |
|---|---|
| `file` | Download a file; optional `decompress = bzip2\|gzip\|xz\|zstd`, `executable`, `private`, `readonly`, `encrypted`. |
| `archive` | Extract a directory; `exact`, `stripComponents`, `include`/`exclude`, `format`, `archive.extractAppleDouble`. |
| `archive-file` | Extract one member; `path`, `stripComponents`, `executable`. |
| `git-repo` | Clone a repo; `clone.args`, `pull.args`, `refreshPeriod`. |

Common fields: `url`/`urls` (https/http/file), `checksum.sha256|384|512`, `checksum.size`, `refreshPeriod`, `filter.command`/`args`, `targetPath`, `encrypted`. Downloads cache in `cacheDir`; refresh with `--refresh-externals=always|auto|never` or `refreshPeriod`.

## Secrets and encryption

- Top-level `encryption = "age" | "gpg" | "transparent"` (never an `[encryption]` section). `age` needs `identity`/`identities` and `recipient`/`recipients`; supports `symmetric` and `passphrase`. Builtin age is used when the `age` binary is absent and does not support passphrases, symmetric mode, or SSH keys. `gpg` uses `recipient`/`recipients`, `symmetric`, `args`. `transparent` delegates to transcrypt/git-crypt.
- `chezmoi age-keygen --output=key.txt`; `chezmoi add --encrypt ~/.ssh/id_rsa`; `chezmoi chattr +encrypted <target>`; `chezmoi edit` decrypts and re-encrypts; `chezmoi edit-encrypted` edits ciphertext; `chezmoi re-add --re-encrypt` re-encrypts with the current key.
- Keyring: `chezmoi secret keyring set/get/delete --service=... --user=...` (value prompted or `--value`).
- Custom manager: `[secret] command = ...`, `args = [...]`, then `{{ secret "show" "path" }}` / `{{ secretJSON "get" "item" }}`.
- Secret scanning: `chezmoi add --secrets error <target>` or `[add] secrets = "error"`. It is a heuristic, not a guarantee.
- A rendered destination always contains plaintext unless the app supports env/keyring indirection. `private_` gives 0600; it does not hide the value from processes running as you.
- For a public repo, commit only lookups (password-manager expressions, env lookups, prompts), never literals. If a secret lands in history, rotate it and rewrite history.

## Machine differences

- Templates keyed on `.chezmoi.os`, `.hostname`, `.arch`, `.osRelease`, or `.data.*`.
- `.chezmoiignore` for whole files/directories per machine.
- `.chezmoitemplates/` for shared content used at different target paths.
- Completely different files: conditional template content or per-machine ignore.
- Store answers in `.chezmoi.toml.tmpl` → `[data]`; regenerate with `chezmoi init` (or any command with `--init`). `init --promptString k=v` and `--promptDefaults` make setup reproducible; `--override-data` injects one-off data.
- New machine: `chezmoi init --apply <repo>` clones, renders the config, and applies. `--one-shot` is `--apply --depth=1 --force --purge --purge-binary` for ephemeral hosts.

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

## Partial management

- `modify_` script: stdin = current content, stdout = new content. A first line `{{- /* chezmoi:modify-template */ -}}` turns the rest into a template with `.chezmoi.stdin`; `setValueAtPath` edits JSON/JSONC/TOML/YAML. Modify templates must not end in `.tmpl`.
- `create_` plus `private_`/`executable_`/`readonly_` creates the file if missing and enforces permissions without touching content.
- `remove_` removes an entry without owning its contents; `run_` scripts can set permissions only if the file already exists.
- `include` is literal; `includeTemplate` executes a partial; `output` captures a command; `exec` only reports success.

## Safety

- `chezmoi add` copies the destination over the source; run `chezmoi diff` first or you lose newer template content.
- `apply` on a file changed since the last write prompts for a reason; prefer `chezmoi merge <target>` to reconcile instead of overwriting.
- `exact_`, `destroy`, `purge`, `.chezmoiremove` are destructive: list targets and dry-run first. `re-add` on an `exact_` directory mirrors the destination, so it can delete source entries.
- This machine sets `git.autoCommit` and `git.autoPush`; `add`, `edit`, `chattr`, `re-add`, `forget`, and `destroy` commit and push immediately. Confirm before changing source; there is no per-command opt-out. `autoAdd` means `git add .`, not destination capture.
- `chezmoi cat` prints decrypted content; avoid it on secrets in shared logs.
- Never edit source or destination while `apply` is running; never call a source-modifying chezmoi command from a `run_` script or hook.

## Diagnose

```bash
chezmoi doctor
chezmoi verify                    # exit 1 if any target differs
chezmoi managed | unmanaged | ignored
chezmoi dump <target>             # target state as data
chezmoi state dump                # script hashes, last-written times
chezmoi cat-config                # merged config
chezmoi source-path <target>      # which source entry backs a target
chezmoi --verbose --debug <cmd>   # step-by-step
```

Template error → `chezmoi execute-template < file.tmpl`. Conflict → `chezmoi merge`. Drift → `chezmoi re-add` or reapply. State lock timeout → another chezmoi is running. `chezmoi apply --dry-run --verbose` previews everything.

The installed binary is the authority for syntax: `chezmoi help <command>`. Full reference: https://www.chezmoi.io/reference/ · commands https://www.chezmoi.io/reference/commands/ · attributes https://www.chezmoi.io/reference/source-state-attributes/ · config variables https://www.chezmoi.io/reference/configuration-file/variables/ · template functions https://www.chezmoi.io/reference/templates/functions/.
