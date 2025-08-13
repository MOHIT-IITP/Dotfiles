export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh


# Shell enhancements
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Aliases
alias python=/usr/bin/python3
alias vi="nvim"
alias v="vim"
alias cd="z"
alias ls="eza"
alias ll="eza --long"
alias la="eza --long --all"
alias lt="eza --tree"
alias ys="yay -S"
alias ysu="yay -Syu"
alias ff="yazi"
alias ta="tmux a"
alias editzsh="nvim ~/.zshrc"
alias sourcezsh="source ~/.zshrc"

# Git shortcuts
alias ga="git pull origin main && git add ."
alias gc="git commit -m"
alias gp="git push origin main"
alias gpl="git pull origin main"
alias gs="git status"

# Project shortcuts
alias mg="cd ~/moLib/moGit"
alias nrd="npm run dev"
alias nrs="npm run start"
alias nrb="npm run build"

# Tmux: attach or create session named 'default'
[ -z "$TMUX" ] && (tmux attach-session -t default || tmux new-session -s default)

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"


export EDITOR="nvim"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

