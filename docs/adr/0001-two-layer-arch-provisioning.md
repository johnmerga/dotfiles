# Two-layer Arch provisioning from a public repo

We provision new Arch machines in two layers: a **base install** driven by an
`archinstall` JSON config fetched from this public repo via a `curl | bash`
one-liner on the official ISO, and a **post-install** layer of `setup-0x` scripts
run after first reboot. The base install bakes in stable preferences (bootloader,
kernel, network, locale, audio, graphical base) but leaves disk partitioning and
all passwords interactive.

## Considered Options

- **Custom pre-built ISO** (archiso with config baked in) — rejected: must rebuild
  and re-flash the ISO on every config change; heavier to maintain than a config
  fetched live.
- **Fully automated disk wipe** (hardcoded device in the JSON) — rejected:
  disk names differ across machines (`nvme0n1` vs `sda`) and a wrong wipe is
  unrecoverable. The ~30s of clicking the disk menu is cheap insurance.
- **Private creds file for passwords** — rejected: adds a token/secret-store to
  manage for a machine that's installed only occasionally; typing two passwords
  interactively is simpler and leaks nothing into the public repo.

## Consequences

- The config can be edited in git and is used on the next install with no rebuild.
- Disk and password steps require a human at the keyboard — installs are
  semi-attended by design, not headless.
- Graphical-base packages are owned exclusively by Layer 1 and must never be added
  to the post-install scripts, or they will drift and double-install.
