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
- **Layer 2 — post-install** (`setup-01/02/03`): run after first reboot. CLI/dev
  tools, AUR apps, dotfiles, and machine enablements (default shell, docker,
  bluetooth, audio check). Safe to re-run on an existing machine.

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
   ~/dotfiles/setup-01-bootstrap   # CLI/dev tools, AUR, dotfiles, zsh + docker
   ~/dotfiles/setup-02-desktop     # desktop apps, bluetooth, audio check
   ~/dotfiles/setup-03-devtools    # node (nvm), protoc, starship
   ```

   `setup-01` and `setup-02` let you type comma-separated indexes to skip
   packages per machine.

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

---

## Status bar & power warnings

The i3 bar sits at the **bottom** of every output and reads
`~/.config/i3status/config` from this repo, **not** the system-wide
`/etc/i3status.conf`. Left to right it shows wifi, ethernet, volume, RAM, CPU
load, CPU package temperature, free disk, battery (state + percentage + time
remaining) and the date/clock.

Styling is a Nord palette with per-icon colours, which works because
`general { markup = pango }` is set — that is what allows a `<span>` inside each
module's format string.

Icons are Nerd Font glyphs taken from the **Font Awesome 4 range**
(`U+F000`–`U+F2E0`); that range has been stable across Nerd Fonts releases,
unlike the newer Material and Devicon blocks. They need
`ttf-nerd-fonts-symbols`, installed by `setup-03-devtools` — without it every
icon renders as an empty box. The bar declares a fallback chain
(`JetBrainsMono Nerd Font, Symbols Nerd Font, DejaVu Sans`) so the text stays
readable regardless.

Battery details:

- `battery all` aggregates every `/sys/class/power_supply/BAT*` device, so it
  works whether the firmware names the pack `BAT0` or `BAT1` (the Predator
  PH16-71 reports `BAT1`).
- `last_full_capacity = true` measures charge against what the pack currently
  charges to rather than its factory design capacity, so a worn battery still
  reads 100% when it is actually full.
- Below 20% the reading turns red, matching the first notification threshold.

CPU temperature deliberately sets **no** `path`. i3status defaults to globbing
`/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input`, which survives the
`hwmon` renumbering that happens across reboots — a hardcoded `hwmon7` would
eventually point at the wrong sensor.

`bin/bin/battery-monitor` runs from the i3 config and sends desktop
notifications on AC plug/unplug, at 20% (low) and at 10% (critical, which does
not auto-dismiss). Each threshold fires once per discharge cycle and re-arms
when you plug in. Thresholds are env-overridable:

```bash
BATTERY_LOW=25 BATTERY_CRITICAL=8 BATTERY_INTERVAL=60 battery-monitor
```

Notifications need a running notification daemon — `dunst`, configured at
`config/.config/dunst/dunstrc` and installed by `setup-02-desktop`. Without it
`notify-send` fails outright, so `battery-monitor` falls back to `i3-nagbar` for
critical warnings only.

### Slow links and stale sync dbs

Two failure modes bit this machine and are worth recognising:

- **`pacman -S` after a long gap 404s on every mirror.** A sync db that is weeks
  old names package versions the mirrors have already dropped. The wall of
  `failed retrieving file ... 404` is not a mirror problem. Always `-Syu`, never
  a bare `-S`, which is what the `setup-0x` scripts now do.
- **`Operation too slow. Less than 1 bytes/sec` aborts tiny transfers.** On a
  throttled link (e.g. routed through a free VPN) pacman's download timeout
  kills stalled `.sig` fetches. The scripts pass
  `--disable-download-timeout` to avoid this.

Icons only need `ttf-nerd-fonts-symbols` (1.2 MiB), *not* the 11 MiB patched
JetBrains Mono — the bar's fallback chain lets DejaVu render the text while the
symbol font supplies the glyphs. Useful when bandwidth is scarce.

> **Gotcha:** i3 inherits a bare `PATH` from the display manager — no `~/bin`,
> no `~/.local/bin`. Scripts shipped by these dotfiles must be referenced from
> the i3 config by absolute path (`$HOME/bin/...`), or the `exec` silently does
> nothing.
