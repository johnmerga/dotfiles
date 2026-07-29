# Dotfiles & Arch provisioning

Personal dotfiles plus a two-layer setup that takes a machine from a blank disk
to a working environment. See [CONTEXT.md](./CONTEXT.md) for the vocabulary and
[docs/adr/0001-two-layer-arch-provisioning.md](./docs/adr/0001-two-layer-arch-provisioning.md)
for why it's built this way.

---

## The two layers

- **Layer 1 — base install** (`bootstrap.sh` + `archinstall.json`): driven from
  the official Arch ISO. Partitions, bootloader, kernel, network, locale, audio,
  and the graphical base. Ends at first reboot into a working i3 desktop with
  sound and wifi.
- **Layer 2 — post-install** (`setup-01/02/03/04`): run after first reboot. CLI/dev
  tools, AUR apps, dotfiles, and machine enablements (default shell, docker,
  bluetooth, audio check, NetworkManager). Safe to re-run on an existing machine.

The dividing line: "can I see a screen and hear sound" is Layer 1; "can I work"
is Layer 2.

---

## Fresh machine, from scratch

1. Boot the **official Arch ISO** and get online:
   - wired usually just works
   - wifi: `iwctl` → `station wlan0 connect <SSID>`
2. Download and run the bootstrap (download first — don't pipe `curl | bash`,
   or archinstall's menu can't read the keyboard):

   ```bash
   curl -fsSL https://raw.githubusercontent.com/johnmerga/dotfiles/main/bootstrap.sh -o bootstrap.sh
   bash bootstrap.sh
   ```

   You will **pick the target disk** and **set passwords** interactively — these
   are never stored in this public repo. Everything else comes from
   `archinstall.json`.
3. The script clones this repo into `~/dotfiles` before reboot.
4. Reboot and log in to i3.
5. Run the post-install layer:

   ```bash
   ~/dotfiles/setup-01-bootstrap   # CLI/dev tools, editors, AUR, dotfiles, zsh + docker
   ~/dotfiles/setup-02-desktop     # desktop apps, brightness, automount, bluetooth, audio
   ~/dotfiles/setup-03-devtools    # node (nvm), protoc, starship
   ~/dotfiles/setup-04-network     # wifi hotspot, WireGuard, ProtonVPN
   ```

   `setup-01`, `setup-02` and `setup-04` let you type comma-separated indexes to
   skip packages per machine.

### What lands where

| Script | Notable contents |
| --- | --- |
| `setup-01` | neovim, ghostty, tmux, zsh, fzf/ripgrep/bat/fd, lazygit, lazydocker, docker, openssh, man-db/man-pages, pyenv, VS Code, Postman, Slack, Telegram |
| `setup-02` | obsidian, brave, thunar, flameshot, gwenview, feh, udiskie, brightnessctl, monitask, bluetooth, powerlevel10k |
| `setup-03` | node via nvm, protoc, starship |
| `setup-04` | networkmanager, wireless_tools, iptables, dnsmasq, hostapd, linux-wifi-hotspot, wireguard-tools, proton-vpn-gtk-app |

### Post-install manual steps

A few things can't be scripted from a public repo:

- **WireGuard**: drop your tunnel at `/etc/wireguard/wg-t1.conf` (`chmod 600`),
  then toggle with `~/bin/wg` or `$mod+Shift+w`.
- **ProtonVPN**: sign in through the GUI once.
- **Wallpapers**: put images in `~/Pictures/background/` (i3 sets them with feh).
- **Brightness/docker groups**: log out and back in so `video` and `docker`
  group membership takes effect.

> **Note:** archinstall's config schema changes between releases. Before
> committing to a disk, sanity-check that the menu pre-fills correctly (or use
> `archinstall --config archinstall.json --dry-run` if your version supports it).
> The `profile_config` / `greeter` keys are the most likely to need adjusting.

---

## Existing machine (dotfiles only)

This repo uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink configs.
Packages: `bash`, `zsh`, `config`, `bin`.

```bash
git clone https://github.com/johnmerga/dotfiles ~/dotfiles
cd ~/dotfiles
sudo pacman -S stow          # or: sudo apt install stow
stow bash zsh config bin
```

For tmux plugins (TPM is installed by `setup-01-bootstrap`, or clone manually):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Start tmux and press your prefix (`Alt + a`) then `I` (capital i) to install plugins.

### Notes

- If you already have conflicting files, remove them before stowing, or let
  `setup-01-bootstrap` run `stow --adopt`.
- Each top-level folder is a stow package.
