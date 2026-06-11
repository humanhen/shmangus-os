# Shmangus OS

A custom Linux distribution based on **Debian 12 (bookworm)**, built with
[live-build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html).
It produces a hybrid live ISO (bootable from USB or DVD, BIOS and UEFI) with a
graphical installer, so you can try it live or install it to disk.

**Version 1.0 "Big Shmang"** ships:

- XFCE desktop with custom Shmangus OS branding (wallpaper, MOTD, os-release)
- LightDM login manager
- Firefox ESR, NetworkManager, PipeWire audio
- Non-free firmware and microcode included, so Wi-Fi works on most laptops
- Everyday tools: git, vim, htop, neofetch, GParted, and more

## Building the ISO

### Option 1: GitHub Actions (no local setup)

Every push to `main` (or a manual run of the **Build Shmangus OS ISO**
workflow under the Actions tab) builds the ISO and uploads it as an
artifact called `shmangus-os-iso`, together with a SHA256 checksum.

### Option 2: Docker (any Linux/macOS machine)

```sh
./build.sh docker
```

This builds a small Debian builder image and runs live-build inside it
(`--privileged` is required for the chroot and loop devices). The ISO lands
in the repository root as `shmangus-os-amd64.hybrid.iso`.

### Option 3: Native Debian host

```sh
sudo apt install live-build
sudo ./build.sh
```

A full build downloads ~1.5 GB of packages and takes 20–40 minutes
depending on bandwidth and disk speed.

## Trying it

```sh
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom shmangus-os-amd64.hybrid.iso
```

or write it to a USB stick:

```sh
sudo dd if=shmangus-os-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

The live session logs in automatically as user `shmangus` (password: `live`,
the live-config default). Choose "Install" from the boot menu to install to
disk.

## Project layout

```
auto/config                       live-build settings (distro base, ISO metadata, boot options)
config/package-lists/             which packages go in (one package per line, *.list.chroot)
config/hooks/normal/              scripts run inside the chroot during build (branding)
config/includes.chroot/           files copied verbatim into the system (wallpaper, MOTD, skel)
build.sh                          build entry point (native or Docker)
.github/workflows/build-iso.yml   CI build that uploads the ISO artifact
```

## Customizing

- **Add/remove software:** edit the files in `config/package-lists/`. Any
  package in the Debian bookworm archive works.
- **Change branding/version:** edit
  `config/hooks/normal/0100-shmangus-branding.hook.chroot` and the wallpaper
  at `config/includes.chroot/usr/share/backgrounds/shmangus/shmangus.svg`.
- **Drop in arbitrary files:** anything under `config/includes.chroot/`
  is copied into the root filesystem at the same path.
- **Swap the desktop:** replace the XFCE packages in
  `config/package-lists/desktop.list.chroot` (e.g. with `kde-plasma-desktop`
  or `gnome-core`).
- **Change the base release:** edit `--distribution` in `auto/config`.

## Ideas for later

- Custom boot splash (Plymouth theme) and themed GRUB/syslinux boot menu
- Calamares installer instead of the stock Debian installer
- A `shmangus-apt` repository for distro-specific packages
- Pre-seeded Flatpak + Flathub setup
