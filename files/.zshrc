####################################
#  ___ _   _ ___  ___ ___  __  __  #
# | __| | | | _ \/ __/ _ \|  \/  | #
# | _|| |_| |   / (_| (_) | |\/| | #
# |_|  \___/|_|_\\___\___/|_|  |_| #
#                                  #
#    .zshrc Version 2024-10-01     #
#                                  #
####################################

################
## 1. SOURCES ##
################

#source ~/.cache/wallust/sequences

################
## 2. EXPORTS ##
################
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export VISUAL=vim
export EDITOR=vim
export TERM=kitty
export PATH=$PATH:$HOME/.config/oh-my-posh

##############
## 3. ZINIT ##
##############
# 1. Set the Zinit directory
ZINIT_HOME="${HOME}/.local/share/zinit"

# 2. Load completions
autoload -Uz compinit && compinit

# 3. Download Zinit if not existing
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 4. Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# 5. Zinit ZSH plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# 6. Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::debian
zinit snippet OMZP::docker
zinit snippet OMZP::command-not-found
zinit cdreplay -q

# 7. Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

####################
## 4. KEYBINDINGS ##
####################
bindkey -e
bindkey '^[w' kill-region
bindkey '^s' fzf-cd-widget
bindkey '^u' fzf-file-widget
bindkey '^f' fzf-history-widget
bindkey '^[[B' history-search-forward
bindkey '^[[A' history-search-backward
bindkey "^[[3~" delete-char

################
## 5. HISTORY ##
################
HISTDUP=erase
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
setopt sharehistory
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_all_dups

################
## 6. ALIASES ##
################
# Programs
alias neofetch="fastfetch"
alias vim="nvim"

# Navigation
alias ls="ls --color"
#alias d="ls -hals --group-directories-first"
alias d="echo '' && eza --all --header --long --group --time=modified --group-directories-first --icons=always --time-style='+%Y-%m-%d %H:%M:%S'"
alias \#="cd .. ; d"
alias c="clear"
alias q="exit"

# Configs
alias aa="cd $HOME/.config/ags && d"
alias zz="vim $HOME/.zshrc"
alias bb="vim $HOME/.bashrc"
alias kk="vim $HOME/.config/kitty/kitty.conf"
alias nn="vim $HOME/.config/nvim/init.lua"

# SSH
eval $(ssh-agent) >/dev/null
alias keys="cd $HOME/.ssh"
alias delkey="ssh-add -D"
alias addkey="eval `ssh-agent` ; ssh-add $HOME/.ssh/id_ed25519"

# Update
alias update="sudo pacman -Syu ; yay -Syu"

# Git
alias githome='git add . ; git commit -m "Updates" ; git push https://furcom:$(sudo cat $HOME/.git_pat)@github.com/furcom/HomeLab.git main'
alias gitarch='git add . ; git commit -m "Updates" ; git push https://furcom:$(sudo cat $HOME/.git_pat)@github.com/furcom/arch-furcom.git main'
alias gitfypr='git add . ; git commit -m "Updates" ; git push https://furcom:$(sudo cat $HOME/.git_pat)@github.com/furcom/fyprland.git main'

# Reboot
alias reboot="systemctl reboot"
alias poweroff="systemctl poweroff"

##################
## 7. AUTOSTART ##
##################
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.yaml)"
fastfetch
