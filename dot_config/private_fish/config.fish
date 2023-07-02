# Remove fish greeting
set fish_greeting

#
## ALIASES
#

# Quick aliases
alias v='nvim'
alias df='df -h'
#alias free='free -m'

# Ls
alias ls='lsd --group-dirs first' # shows directories first
alias l='ls -l' # detailed ls
alias la='ls -A' # ls with hidden files
alias ll='ls -lA' # detailed ls with hidden files
alias lt='ls --tree'

# Git related
alias gitpullrecursive='find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'
alias gcl='git clone'
alias gps='git push'
alias gpl='git pull'
alias gst='git status -s'
alias gstt='git status'
alias gad='git add'
alias gdf='git diff'
alias gcm='git commit -m'
alias gchm='git commit --amend -m'
alias gls='git ls-files'
alias glsn='git ls-files | wc -l'
alias gco='git checkout'
alias gbr="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias glg='git log --oneline'
#git log --pretty=format:"%C(yellow)%h %Creset%s %Cblue[%cn]"
alias glgg='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --date=short'
alias glgs='git log --pretty=format:"%C(yellow)%h %ad%Cred%d | %Creset%s%Cblue [%cn]" --decorate --date=short'
alias glgr='git log --pretty=format:"%C(yellow)%h %ad%Cred%d | %Creset%s%Cblue [%cn]" --decorate --date=relative'
#alias ggll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'

# Pacman / yay
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias yayes='yay -Syu --sudoloop --noconfirm'
alias pacman_cache='paccache -ruvk 0 && paccache -rvk 2'
alias pacman_orphaned='sudo pacman -Rns (pacman -Qtdq)' # Remove orphaned packages
alias pacman_purge='yay -Sc && yay -c' # Clear cache and unused packages
alias mirror_update='curl -s "https://archlinux.org/mirrorlist/?country=FR&country=GB&country=DE&protocol=https&use_mirror_status=on" | sed -e "s/^#Server/Server/" -e "/^#/d" | rankmirrors -n 5 -'

# 42 related
alias clean_coderunner='find . -maxdepth 1 -type f -name "ft*" ! -name "*.c" -delete' # clean unused test compiled files from vscode coderunner extensions
alias 42tester='/home/maplepy/Github/42/testers/francinette/tester.sh'

# Systemctl
alias sstart='sudo systemctl start'
alias srstart='sudo systemctl restart'
alias sstop='sudo systemctl stop'
alias sstatus='sudo systemctl status'
alias slist='systemctl list-unit-files --state=enabled'
alias se='sudoedit'

# Misc
alias grub_regen='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias pastehere='sleep 2; xdotool type "$(xclip -o -selection clipboard)"'
alias cleanemptydir='sudo find . -type d -empty -delete' # remove empty directories

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
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# temporary
# alias 1280p='xrandr --output Virtual-1 --mode 1280x720 && bspc wm -r'
# alias 1024p='xrandr --output Virtual-1 --mode 1024x768 && bspc wm -r'
# alias 1920p='xrandr --output Virtual-1 --mode 1920x1080 && sleep 1 && bspc wm -r'

alias grep='grep --color=auto'
alias egrep='grep --color=auto -E'
alias fgrep='grep --color=auto -F'

#
## EXPORTS
#

# export PATH='":$PATH
export EDITOR='nvim'
export SUDO_EDITOR='vim'
export TERMINAL='alacritty'
export MANPAGER='nvim +Man!'
# export MANWIDTH=999
