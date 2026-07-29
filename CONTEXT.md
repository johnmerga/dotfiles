# Dotfiles & Arch Provisioning

This repo provisions a personal Arch Linux machine from a fresh install to a
working environment. Provisioning happens in two distinct layers; the language
below keeps those layers and their responsibilities from blurring together.

## Language

**Base install** (Layer 1):
The phase driven by the official Arch ISO and an `archinstall` JSON config:
partitioning, bootloader, kernel, network, locale, and the *graphical base*. Ends
at first reboot into a usable i3 desktop with sound and wifi.
_Avoid_: bootstrap, initial setup.

**Post-install** (Layer 2):
Everything run after first reboot by the `setup-0x` scripts: CLI/dev tools, AUR
apps, dotfiles, and *enablements*. Re-runnable on an existing machine. Scripts
split by concern, not by install order: `01` CLI/dev, `02` desktop, `03` language
toolchains, `04` network (hotspot + VPN). A package belongs to the script whose
*enablements* it shares.
_Avoid_: bootstrap (overloaded), arch-setup (the deleted legacy scripts).

**Graphical base**:
The minimal package set archinstall installs so first reboot lands in a working
desktop: xorg, i3, kitty, rofi, the audio stack, firefox, NetworkManager. The
dividing line is "can I see a screen and hear sound" (base install) vs. "can I
work" (post-install). These packages never appear in the post-install scripts.

**Preferences**:
What the user means by "the installer knowing my setup." Three different things,
never conflated: (1) **config values** baked into the archinstall JSON (timezone,
keyboard, audio backend); (2) **packages** to install; (3) **enablements** —
machine-level state changes. "Audio" is a preference spanning all three: a backend
choice (pipewire), packages, and an enabled service.
_Avoid_: settings, config (ambiguous on their own).

**Enablement**:
A machine-level state change beyond installing a package: setting zsh as the
default shell, enabling the docker service and group, adding the user to `video`
for brightness control, enabling bluetooth and NetworkManager, confirming audio
services are active. Distinct from installing the package that makes the change
possible. Note the inverse also counts as a decision: `hostapd` and `dnsmasq` are
installed but deliberately *left disabled*, because linux-wifi-hotspot drives them.
_Avoid_: configuration, setup.

**Dotfiles**:
The stow-managed config files (`bash`, `zsh`, `config`, `bin`) symlinked into the
home directory. Auto-cloned during the base install; stowed during post-install.
_Avoid_: configs, settings.
