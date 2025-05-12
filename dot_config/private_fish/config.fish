# Remove fish greeting
set fish_greeting

## PATH


## ENV
command -q vim; and export EDITOR='vim'
command -q nvim; and export EDITOR='nvim'
command -q helix; and export EDITOR='helix'
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"

export BROWSER='zen-browser'
export PAGER='less'
export TERMINAL='kitty'

#export MANPAGER='nvim +Man!'
export MANWIDTH=999


## ALIASES

# Editors
alias e="$EDITOR"
alias se='sudoedit'
command -q windsurf; and alias ws='windsurf'


# Quick aliases
command -q jump; and alias j='jump'
alias ka='killall'
alias df='df -h'
alias dus='du -sh'
alias free='free -m'

# Aliases: Ls
if command -q lsd
    alias ls='lsd --group-dirs first --hyperlink auto'
    alias la='ls -A' # Show hidden files
    alias ll='ls -l' # Detailed ls
    alias lla='ls -lA' # Detailed ls with hidden files
    alias lt='ls --tree' # Tree ls
    alias lta='lt -A' # Tree ls with hidden files
end

# Aliases: Paru
if command -q paru
    alias p='paru'
    alias ps='paru -S'              # Install
    alias pr='paru -Rns'            # Remove package and its dependencies
    alias psi='paru -Si'            # Get detailed information about a package
    alias pq='paru -Q'              # Query package database
    alias pyc='paru -Sc'            # Clean package cache
    alias pycc='paru -Scc'          # Clean all package cache
    alias pyao='paru -Qtd'          # List orphaned packages
    alias pyro='paru -Rns (paru -Qtdq)' # Remove orphaned packages
    function paclean
        paru -Sc
        set orphans (paru -Qtdq)
        if test (count $orphans) -gt 0
            paru -Rns $orphans
        end
    end
end

# Aliases: Git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gbr="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gcm='gc --amend -m'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gdf='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gdf --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gps='git push'
alias gr='git reset'
alias gs='git status --short'
alias gpl='git pull'
alias gsm='git submodule'
alias gls='git ls-files'
alias glgc='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
function gcm
    git commit --message "$argv"
end

function pr_template
    if test ! (git rev-parse --is-inside-work-tree)
        return 1
    end

    set origin_branch (git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if test "$origin_branch" = "origin/main"
        set target_branch "main"
    else
        set target_branch "master"
    end
    echo -e "\n## 🔑 Key Changes"; \
    git log $target_branch..HEAD --oneline | grep -E "feat|fix|BREAKING CHANGE" | sed 's/^/- /'; \
    echo -e "\n## 📁 Areas Affected"; \
    git diff --name-status $target_branch...HEAD | sed 's/^/- /'; \
    echo -e "\n## 📝 Additional Notes"; \
    git log $target_branch..HEAD --format="%B" | grep -i "^note:" | sed 's/^Note: *//i' | sed 's/^/- /'; \
    echo -e "\n## �� Related Issues/PRs"; \
    git log $target_branch..HEAD --oneline | grep -o '#[0-9]\+' | sort -u | sed 's/^/- Issue /'
end


# Aliases: chezmoi
if command -q chezmoi
    alias cz='chezmoi'
    alias cad='cz add'
    alias ced='cz edit --apply'
    alias cedit='cz edit'
    alias cdf='cz diff'
    alias cst='cz status'
    alias czu='cz update'
end

# Aliases: Kitty
[ "$TERM" = "xterm-kitty" ] && alias s="kitty +kitten ssh"
[ "$TERM" = "xterm-kitty" ] && alias d="kitty +kitten diff"
[ "$TERM" = "xterm-kitty" ] && alias icat="kitty +kitten icat"
[ "$TERM" = "xterm-kitty" ] && alias g="kitty +kitten hyperlinked_grep"



function z
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# File search in package database
alias yf='y -Fy'

# Query package that owns a file
alias yq='y -Qo'

# Install a package
alias ys='y -S'

# Search for a package
alias yss='y -Ss'

# Remove a package and its dependencies
alias yr='y -Rcn'
alias yrr='y -Rcns'
alias yrrr='y -Rcnss'

# Update system and AUR packages
alias yy='y -Syu --sudoloop --noconfirm'

# Clean unneeded dependencies
alias yo='y -Yc'

# Clean package cache
alias yc='y -Sc'

# Clean all package cache
alias ycc='y -Scc'

# List orphaned packages
alias yao='yay -Qtd'

# Remove orphaned packages
alias yro='yay -Rns $(yay -Qtdq)'

# Get detailed information about a package
alias yi='yay -Si'

# List files owned by a package
alias ylf='yay -Ql'

# Check for outdated AUR packages
alias yau='yay -Qua'

# Show package dependency tree
alias ydt='yay -Qi'

# Function to display alias descriptions
function yay_help
    echo "Yay Alias Descriptions:"
    echo "y    - Basic yay command"
    echo "yf   - File search in package database"
    echo "yq   - Query package that owns a file"
    echo "ys   - Install a package"
    echo "yss  - Search for a package"
    echo "yr   - Remove a package and its dependencies"
    echo "yy   - Update system and AUR packages"
    echo "yo   - Clean unneeded dependencies"
    echo "yc   - Clean package cache"
    echo "ycc  - Clean all package cache"
    echo "yao  - List orphaned packages"
    echo "yro  - Remove orphaned packages"
    echo "yi   - Get detailed information about a package"
    echo "ylf  - List files owned by a package"
    echo "yau  - Check for outdated AUR packages"
    echo "ydt  - Show package dependency tree"
end

# Alias for the help function
alias yhelp='yay_help'

# pacman
alias unlock_pacman='sudo rm /var/lib/pacman/db.lck'
alias unlock_sudo='faillock --user $USER --reset'
alias pacman_cache='paccache -ruvk 0 && paccache -rvk 2'
alias pacman_orphaned='sudo pacman -Rns (pacman -Qtdq)' # Remove orphaned packages
alias update-mirrors='sudo reflector --country France,Germany,Belgium,Luxembourg,Switzerland,Italy,Spain,Netherlands,Sweden --latest 20 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syy'


# systemctl
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias sstart='sudo systemctl start'
alias srstart='sudo systemctl restart'
alias sstop='sudo systemctl stop'
alias sstatus='sudo systemctl status'
alias slist='systemctl list-unit-files --state=enabled'

# yt-dlp
alias ytd='yt-dlp'
# audio-only
alias yta='yt-dlp --config-location ~/.config/yt-dlp/audio-config'

# Misc
alias conda_init='eval "$(/home/maplepy/.miniconda3/bin/conda shell.fish hook)"'
alias cleanemptydir='find . -type d -empty -delete' # remove empty directories

#
## EXPORTS
#

## Jump
function __jump_add --on-variable PWD
  status --is-command-substitution; and return
  jump chdir
end

function __jump_hint
  set -l term (string replace -r '^j ' '' -- (commandline -cp))
  jump hint "$term"
end

function j
  set -l dir (jump cd "$argv")
  test -d "$dir"; and cd "$dir"
end

complete --command j --exclusive --arguments '(__jump_hint)'
