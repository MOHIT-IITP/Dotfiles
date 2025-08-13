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

