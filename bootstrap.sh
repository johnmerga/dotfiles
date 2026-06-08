#!/usr/bin/env bash
set -euo pipefail

CONFIG_URL="https://raw.githubusercontent.com/johnmerga/dotfiles/main/archinstall.json"
DOTFILES_URL="https://github.com/johnmerga/dotfiles"

echo "=== John's Arch base install (layer 1) ==="
echo
echo "This drives archinstall from a saved config. You will still pick the DISK"
echo "and set PASSWORDS interactively. Make sure you have internet first:"
echo "  - wired:  usually works out of the box"
echo "  - wifi:   run 'iwctl', then: station wlan0 connect <SSID>"
echo
read -rp "Is the network up? [y/N]: " NET
[[ $NET =~ ^[Yy] ]] || { echo "Connect to the internet, then re-run this script."; exit 1; }

TMP="$(mktemp -d)"
echo "Fetching archinstall config..."
curl -fsSL "$CONFIG_URL" -o "$TMP/archinstall.json"

command -v archinstall >/dev/null || { echo "Updating archinstall..."; pacman -Sy --noconfirm archinstall; }

echo
echo "Launching archinstall. Pick your target disk and set passwords when prompted."
archinstall --config "$TMP/archinstall.json"

if [[ -d /mnt/home ]]; then
  USER_NAME="$(find /mnt/home -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | head -1)"
  if [[ -n "${USER_NAME:-}" ]]; then
    echo "Cloning dotfiles into /home/$USER_NAME/dotfiles ..."
    arch-chroot /mnt /usr/bin/bash -c "
      git clone '$DOTFILES_URL' '/home/$USER_NAME/dotfiles' &&
      chown -R '$USER_NAME:$USER_NAME' '/home/$USER_NAME/dotfiles'
    " || echo "WARN: dotfiles clone failed; clone it manually after reboot."
  fi
fi

echo
echo "=== Base install complete ==="
echo "Reboot, log in to i3, then run the post-install layer:"
echo "  ~/dotfiles/setup-01-bootstrap"
echo "  ~/dotfiles/setup-02-desktop"
echo "  ~/dotfiles/setup-03-devtools"
