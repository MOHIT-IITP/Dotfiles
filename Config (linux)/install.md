[!Important]

# Basic tools
```
sudo pacman -S zsh wget neovim curl kitty firefox discord xclip clipboard grim slurp yazi eza zoxide ripgrep base-devel nvidia nvidia-setting nvidia-utils starship unzip btop net-tools git kitty
```

* yay
```
git clone https://aur.archlinux.org/yay
makepkg -si
```

## zsh

* ohmyzsh 
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

* zsh-syntax-highlighting
``` 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \ ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

* zsh-autosuggestions
``` 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```


* zsh config
```
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


alias python=/usr/bin/python3
alias vi="nvim"
alias v="vim"
alias cd="z"
alias ga="git pull origin main && git add ."
alias gc="git commit -m"
alias gp="git push origin main"
alias gpl="git pull origin main"
alias gs="git status"
alias mg="cd ~/moLib/moGit"
alias nrd="npm run dev"
alias nrs="npm run start"
alias nrb="npm run build"
alias ta="tmux a"
alias ls="eza"
alias ll="eza --long"
alias la="eza --long --all"
alias lt="eza --tree"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```


