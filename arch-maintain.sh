#!/bin/bash

# Arch Linux Maintenance Script
# Run as root or use sudo

set -euo pipefail

# Colors for output
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

info() {
  echo -e "${YELLOW}==>${RESET} $1"
}

success() {
  echo -e "${GREEN}✔${RESET} $1"
}

# 1. Update mirrors (optional but helpful)
info "Updating mirrorlist with rate-mirrors (if installed)..."
if command -v rate-mirrors >/dev/null; then
  sudo rate-mirrors arch --save /etc/pacman.d/mirrorlist
  success "Mirrorlist updated"
else
  info "Skipping mirror update (rate-mirrors not installed)"
fi

# 2. Update system (Pacman)
info "Updating system with pacman..."
sudo pacman -Syu --noconfirm
success "System updated"

# 3. Update AUR (yay or paru)
if command -v paru >/dev/null; then
  info "Updating AUR with paru..."
  paru -Syu --noconfirm
  success "AUR updated"
elif command -v yay >/dev/null; then
  info "Updating AUR with yay..."
  yay -Syu --noconfirm
  success "AUR updated"
else
  info "AUR helper not found (yay or paru)"
fi

# 4. Clean old package caches
info "Cleaning old package caches (keeping 1 version)..."
sudo paccache -rk1
success "Old package cache cleaned"

# 5. Clear journal logs older than 2 weeks
info "Vacuuming journal logs (older than 2 weeks)..."
sudo journalctl --vacuum-time=2weeks
success "Old journal logs cleaned"

# 6. Clear user and thumbnail cache
info "Clearing ~/.cache and thumbnails..."
rm -rf ~/.cache/*
rm -rf ~/.cache/thumbnails/*
success "User cache cleaned"

# 7. Optionally reboot if needed
if [[ $(checkupdates | grep -E 'linux|systemd') ]]; then
  info "Kernel or systemd updated — consider rebooting."
else
  success "No reboot required."
fi

echo -e "\n${GREEN}System maintenance complete.${RESET}"
