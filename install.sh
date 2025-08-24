#!/usr/bin/env bash
set -e

# -----------------------------------------
# Helper functions
# -----------------------------------------
install_pacman_pkg() {
    for pkg in "$@"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            echo ">>> $pkg is already installed (skipping)"
        else
            echo ">>> Installing $pkg..."
            sudo pacman -S --noconfirm "$pkg"
        fi
    done
}

install_yay_pkg() {
    for pkg in "$@"; do
        if yay -Qi "$pkg" &>/dev/null; then
            echo ">>> $pkg is already installed (skipping)"
        else
            echo ">>> Installing $pkg..."
            yay -S --noconfirm "$pkg"
        fi
    done
}

# -----------------------------------------
# Update system
# -----------------------------------------
echo ">>> Updating system..."
sudo pacman -Syu --noconfirm

# -----------------------------------------
# Install base packages
# -----------------------------------------
install_pacman_pkg \
  wl-clipboard fzf zsh wget neovim curl kitty firefox discord \
  xclip grim slurp yazi eza zoxide ripgrep base-devel nvidia nvidia-settings \
  nvidia-utils starship unzip btop net-tools git

# -----------------------------------------
# yay install
# -----------------------------------------
if ! command -v yay &>/dev/null; then
  echo ">>> Installing yay (AUR helper)..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# -----------------------------------------
# AUR packages
# -----------------------------------------
install_yay_pkg kanata tmux

# -----------------------------------------
# ZSH + Plugins
# -----------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo ">>> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo ">>> Installing Zsh plugins..."
[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo ">>> Writing .zshrc..."
cat > $HOME/.zshrc <<'EOF'
# --- ZSH CONFIG ---
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
alias ls="eza --icons"
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
EOF

# -----------------------------------------
# Kitty config
# -----------------------------------------
mkdir -p ~/.config/kitty
cat > ~/.config/kitty/kitty.conf <<'EOF'
background_opacity 0.9
window_padding_width 10 

font_family      JetBrainsMono Nerd Font 
bold_font        auto
italic_font      auto
bold_italic_font auto

copy_on_select yes
font_size 16.0
EOF

echo ">>> Installing extra packages..."
yay -S --needed --noconfirm kanata tmux lazygit

# -----------------------------------------
# Tmux config
# -----------------------------------------
echo ">>> Installing tmux plugin manager..."
[ ! -d "$HOME/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# ------------------------
# Setup Tmux config
# ------------------------
echo ">>> Setting up Tmux configuration..."
mkdir -p ~/.config/tmux

cat > ~/.config/tmux/tmux.conf <<'EOF'
#### ------------------------
#### BASIC SETTINGS
#### ------------------------
set -s escape-time 0
set-option -sa terminal-features ',xterm-256color:RGB'
set-option -g allow-passthrough on
set -g base-index 1
set -g renumber-windows on
set-window-option -g mode-keys vi
set-option -g mouse on

#### ------------------------
#### PREFIX AND KEYBINDINGS
#### ------------------------
unbind C-b
set-option -g prefix C-s
bind-key C-s send-prefix

# Split panes
bind _ split-window -v
bind | split-window -h

# Reload config
bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux config reloaded!"

# Vim-style pane switching
bind -n C-h select-pane -L
bind -n C-j select-pane -D
bind -n C-k select-pane -U
bind -n C-l select-pane -R

# Ctrl-^ to go to last window
bind ^ last-window  

# Quick lazygit and custom sessionizer
bind G new-window -n 'lazygit' 'lazygit'
bind f run-shell "tmux neww ~/.config/scripts/tmux-sessionizer.sh"

#### ------------------------
#### STATUS BAR
#### ------------------------
set -g status-position top
set -g status-justify centre
set -g status-style 'fg=color2 bg=default'
set -g status-left '#S'
set -g status-left-style 'fg=color2 dim'
set -g status-right 'Mohiitp'
set -g status-right-length 40
set -g status-left-length 40
setw -g window-status-current-style 'fg=colour3 bg=default bold'
setw -g window-status-current-format '#I:#W'
setw -g window-status-style 'fg=color6 dim'

#### ------------------------
#### PLUGINS
#### ------------------------
set -g @plugin 'tmux-plugins/tpm'

# Useful Plugins
set -g @plugin 'tmux-plugins/tmux-sensible'          # Sensible defaults
set -g @plugin 'tmux-plugins/tmux-resurrect'         # Save/restore tmux sessions
set -g @plugin 'tmux-plugins/tmux-continuum'         # Continuous saving
set -g @plugin 'tmux-plugins/tmux-yank'              # System clipboard yank
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'  # Show prefix status
set -g @plugin 'tmux-plugins/tmux-sessionist'        # Simple session switcher

# Plugin Configs
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'
set -g @resurrect-capture-pane-contents 'on'

# Initialize TMUX plugin manager (keep this at the very bottom)
run '~/.tmux/plugins/tpm/tpm'
EOF





# -----------------------------------------
# Starship config
# -----------------------------------------
mkdir -p ~/.config
cat > ~/.config/starship.toml <<'EOF'
command_timeout = 3600

"$schema" = 'https://starship.rs/config-schema.json'

add_newline = false 

format = """
 ➜\
$directory\
${custom.giturl}\
$git_branch\
$git_state\
$git_status\
$line_break\
$character
"""

right_format = """$all"""

palette = "catppuccin_mocha"

[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
black = "#111112"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"

# [palettes.custom]
# rosewater = "#f5e0dc"
# flamingo = "#eb6f92"
# pink = "#f5c2e7"
# orange = "#cba6f7"
# color_red = '#cc241d'
# red = "#f38ba8"
# maroon = "#eba0ac"
# peach = "#fab387"
# yellow = "#f9e2af"
# green = "#a6e3a1"
# teal = "#94e2d5"
# sky = "#89dceb"
# sapphire = "#74c7ec"
# blue = "#89b4fa"
# lavender = "#b4befe"
# foam = "#9ccfd8"
# pine = "#31748f"
# gold = "#f6c177"
# rose = "#ebbcba"
# text = "#cdd6f4"
# subtext1 = "#bac2de"
# subtext0 = "#a6adc8"
# overlay2 = "#9399b2"
# overlay1 = "#7f849c"
# overlay0 = "#6c7086"
# surface2 = "#585b70"
# surface1 = "#45475a"
# surface0 = "#313244"
# base = "#1e1e2e"
# mantle = "#181825"
# crust = "#11111b"

[os.symbols]
Windows = "󰍲"
Ubuntu = "󰕈"
SUSE = ""
Raspbian = "󰐿"
Mint = "󰣭"
Macos = " "
Manjaro = ""
Linux = "󰌽"
Gentoo = "󰣨"
Fedora = "󰣛"
Alpine = ""
Amazon = ""
Android = ""
Arch = "󰣇"
Artix = "󰣇"
CentOS = ""
Debian = "󰣚"
Redhat = "󱄛"
RedHatEnterprise = "󱄛"

[username]
#show_always = true
#style_user = "bg:surface0 fg:text"
#style_root = "bg:surface0 fg:text"
#format = '[ $user ]($style)'

[directory]
style = "sapphire"
format = "[ $path ]($style)"
#truncation_length = 4
#truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = "󰝚 "
"Pictures" = " "
"Developer" = "󰲋 "

[os]
disabled = true
#style = "bg:surface0 fg:text"

[custom.giturl]
# disabled = true
description = "Display symbol for remote Git server"
command = """
GIT_REMOTE=$(command git ls-remote --get-url 2> /dev/null)
if [[ "$GIT_REMOTE" =~ "github" ]]; then
    GIT_REMOTE_SYMBOL=" "
elif [[ "$GIT_REMOTE" =~ "gitlab" ]]; then
    GIT_REMOTE_SYMBOL=" "
elif [[ "$GIT_REMOTE" =~ "bitbucket" ]]; then
    GIT_REMOTE_SYMBOL=" "
elif [[ "$GIT_REMOTE" =~ "git" ]]; then
    GIT_REMOTE_SYMBOL=" "
else
    GIT_REMOTE_SYMBOL=" "
fi
echo "$GIT_REMOTE_SYMBOL "
"""
when = 'git rev-parse --is-inside-work-tree 2> /dev/null'
format = "at $output"

[git_branch]
symbol = "[](black) "
# format =  ' [$symbol$branch(:$remote_branch)]($style)[]'
style = "fg:lavender bg:black"
format =  '  on [$symbol$branch]($style)[](black)'

[git_status]
format = ' [($all_status$ahead_behind )]($style)'

[nodejs]
symbol = ""
format = '[ $symbol( $version) ]($style)'

[c]
symbol = " "
format = '[ $symbol( $version) ]($style)'

[rust]
symbol = ""
format = '[ $symbol( $version) ]($style)'

[golang]
symbol = ""
format = '[ $symbol( $version) ]($style)'
detect_files = ["go.mod"]

[php]
symbol = ""
format = '[ $symbol( $version) ]($style)'

[java]
symbol = " "
format = '[ $symbol( $version) ]($style)'

[kotlin]
symbol = ""

format = '[ $symbol( $version) ]($style)'

[haskell]
symbol = ""

format = '[ $symbol( $version) ]($style)'

[python]
symbol = ""

format = '[ $symbol( $version) ]($style)'


[docker_context]
symbol = ""
format = '[ $symbol( $context) ]($style)'


[time]
disabled = true
time_format = "%R"
style = "bg:peach"
format = '[[  $time ](fg:mantle bg:foam)]($style)'

[line_break]
disabled = true 

[character]
disabled = false
success_symbol = '[𝘹](bold fg:green)'
error_symbol = '[𝘹](bold fg:red)'
vimcmd_symbol = '[](bold fg:creen)'
vimcmd_replace_one_symbol = '[](bold fg:purple)'
vimcmd_replace_symbol = '[](bold fg:purple)'
vimcmd_visual_symbol = '[](bold fg:lavender)'

EOF

# -----------------------------------------
# Kanata config
# -----------------------------------------
mkdir -p ~/.config/kanata
cat > ~/.config/kanata/kanata.kbd <<'EOF'
(defcfg
    concurrent-tap-hold yes
    log-layer-changes no
    process-unmapped-keys yes
)

(defsrc
    a s d f
    h j k l ;     
    caps    
    v c n m 
    lalt lctl
)

(defvar
    tap-timeout 150
    hold-timeout 250 
)

(defalias
    escctrl (tap-hold $tap-timeout $hold-timeout esc (multi lmet lctl lalt lsft))
    vimnav (tap-hold $tap-timeout $hold-timeout v (layer-toggle vimnav))
    lalt-mod lctl 
    lctl-mod lalt
    cnav (tap-hold $tap-timeout $hold-timeout c (layer-toggle cnav))
    
    ms↑ (movemouse-accel-up 1 1000 1 5)
    ms← (movemouse-accel-left 1 1000 1 5)
    ms↓ (movemouse-accel-down 1 1000 1 5)
    ms→ (movemouse-accel-right 1 1000 1 5)
)

(deflayer base
    a s d f
    h j k l ;
    @escctrl
    @vimnav @cnav n m 
    @lalt-mod @lctl-mod
)

(deflayer vimnav     
    _   _   _   _   
    left    down    up  right   _   
    @escctrl    
    _  _ _ _
    _  _ 
)
(deflayer cnav
    _   _   _   _   
    @ms← @ms↓ @ms↑ @ms→  _   
    @escctrl    
    _  _  mltp mrtp
    _  _ 
)
EOF

echo ">>> Setup complete! 🚀"
echo "👉 Restart your terminal and run: chsh -s $(which zsh)"
