# Remove fish greeting
set fish_greeting

#
## ALIASES
#

# Quick aliases
alias v='nvim'
alias code='codium'
alias ka='killall'
alias ipa='curl ifconfig.me'
alias df='df -h'
alias dus='du -sh'
#alias free='free -m'

# Ls
alias ls='lsd --group-dirs first --hyperlink auto' # shows directories first
alias l='ls -l' # detailed ls
alias la='ls -A' # ls with hidden files
alias ll='ls -lA' # detailed ls with hidden files
alias lt='ls --tree'

# Kitty
[ "$TERM" = "xterm-kitty" ] && alias s="kitty +kitten ssh"
#alias s="kitty +kitten ssh"
alias d="kitty +kitten diff"
alias icat="kitty +kitten icat"
alias hg="kitty +kitten hyperlinked_grep"

# Pacman / yay
alias y='yay'
alias ys='y -S'
alias yss='y -Ss'
alias yr='y -Rcnss'
alias yy='y -Syu --sudoloop --noconfirm'
alias yc='y -Sc'
alias ycc='y -Scc'

alias unlock='sudo rm /var/lib/pacman/db.lck'
alias pacman_cache='paccache -ruvk 0 && paccache -rvk 2'
alias pacman_orphaned='sudo pacman -Rns (pacman -Qtdq)' # Remove orphaned packages
alias mirror_update='curl -s "https://archlinux.org/mirrorlist/?country=FR&country=GB&country=DE&protocol=https&use_mirror_status=on" | sed -e "s/^#Server/Server/" -e "/^#/d" | rankmirrors -n 5 -'

# Git related
alias gitpullrecursive='find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'
alias gcl='git clone'
alias gps='git push'
alias gpl='git pull'
alias gst='git status -s'
alias gstt='git status'
alias gsm='git submodule'
alias gad='git add'
alias gdf='git diff'
alias gdd="git difftool --no-symlinks --dir-diff"
alias gcm='git commit -m'
alias gchm='git commit --amend -m'
alias gls='git ls-files'
alias glsn='git ls-files | wc -l'
alias gco='git checkout'
alias gbr="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias glg='git log --oneline | head -n 15'
#git log --pretty=format:"%C(yellow)%h %Creset%s %Cblue[%cn]"
alias glgg='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --date=short'
alias glgs='git log --pretty=format:"%C(yellow)%h %ad%Cred%d | %Creset%s%Cblue [%cn]" --decorate --date=short'
alias glgr='git log --pretty=format:"%C(yellow)%h %ad%Cred%d | %Creset%s%Cblue [%cn]" --decorate --date=relative'
#alias ggll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'

# Systemctl
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias sstart='sudo systemctl start'
alias srstart='sudo systemctl restart'
alias sstop='sudo systemctl stop'
alias sstatus='sudo systemctl status'
alias slist='systemctl list-unit-files --state=enabled'
alias se='sudoedit'

# Misc
alias grub_regen='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias pastehere='sleep 2; xdotool type "$(xclip -o -selection clipboard)"'
alias cleanemptydir='find . -type d -empty -delete' # remove empty directories

# Config files
alias modalacritty='v ~/.config/alacritty/alacritty.yml'
alias modbspwm='v ~/.config/bspwm/bspwmrc'
alias moddocker='v /docker/docker-compose.yml'
alias moddunst='v ~/.config/dunst/dunstrc'
alias modfish='v ~/.config/fish/config.fish'
alias modgit='v ~/.gitconfig'
alias modmpv='v ~/.config/mpv/'
alias modpicom='v ~/.config/picom/picom.conf'
alias modpolybar='v ~/.config/polybar'
alias modsxhkd='v ~/.config/sxhkd/sxhkdrc'
alias modvim='v ~/.config/nvim/init.vim'

alias fishreload='source ~/.config/fish/config.fish'

# Dotfiles
alias cz='chezmoi'
alias cad='cz add'
alias ced='cz edit --apply'
alias cedit='cz edit'
alias cdf='cz diff'
alias cst='cz status'
alias czu='cz update'

# Colouring
alias grep='grep --color=auto'
alias egrep='grep --color=auto -E'
alias fgrep='grep --color=auto -F'

#
## EXPORTS
#

# export PATH='":$PATH
export EDITOR='nvim'
export SUDO_EDITOR=$EDITOR
export TERMINAL='alacritty'
export MANPAGER='nvim +Man!'
# export MANWIDTH=999
