# Rsync Local for Home Assistant

![Version 1.73](https://img.shields.io/badge/version-1.73-167D8D?style=for-the-badge)
![AMD64 and ARM64](https://img.shields.io/badge/architectures-amd64%20%7C%20aarch64-41BDF5?style=for-the-badge)

**Version 1.73**

Your Home Assistant setup holds a lot of little things that would be hard to recreate: carefully tuned automations, configuration files, secrets, and the resources you keep in `/share` and `/media`. Rsync Local helps you keep an extra copy close to home.

Plug a USB stick, USB hard drive, or USB SSD directly into your Home Assistant server, choose the folders that matter to you, and let a Home Assistant automation run the sync on your schedule. No NAS is required. If you already have one, this gives you another local place to keep your important files.

[![Add repository to Home Assistant](https://img.shields.io/badge/Add-repository-41BDF5?logo=home-assistant&style=for-the-badge)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseb5594%2FHome-Assistant-Apps)

## What you can keep

- Home Assistant configuration, automations, scripts, dashboards, and `secrets.yaml` from `/config`.
- Selected files or entire folders from `/share` and `/media`, such as voice resources, playlists, and documents.
- Other exposed folders, including `/ssl`, `/backup`, and `/addon_configs`, when you include them in the configuration.

Rsync copies new and changed files on later runs, so you do not have to copy everything from scratch each time. You decide whether to include a whole folder or just a smaller collection of essentials.

## A simple routine

1. Add the [Home Assistant Apps repository](https://github.com/seb5594/Home-Assistant-Apps) and install **Rsync Local**.
2. Attach a prepared USB drive to the Home Assistant server. For a virtual machine, pass the drive through to the Home Assistant OS guest.
3. Start the app with `external_device` left empty to list candidate devices in the log, then identify the correct USB partition.
4. Set the partition, choose your source folders, and run your first sync.
5. Create a time-based Home Assistant automation to start the app periodically, for example every night.

**Each start performs one sync and then exits.** Scheduling belongs to Home Assistant; the app has no internal timer.

See the [configuration and scheduling guide](rsync-local/DOCS.md) for examples, device selection, and restore considerations.

## What kind of backup is this?

This is an extra local file copy for the parts of your setup you want within reach. The default rsync options use `--delete`, so deleted source files are also removed from their corresponding destination folders. There is no built-in version history or encryption.

Keep Home Assistant's own backups for complete restores and consistent application data. A file sync of a running database does not guarantee a usable database backup. Copies containing secrets deserve the same care as the originals.

## Version and maintenance

Version **1.73** is built locally by Home Assistant from this repository. It does not download a Poeschl application image. Installation and updates need access to the Home Assistant base image and Alpine packages.

The current build supports **AMD64** and **ARM64 / AArch64**, the architectures supported by current Home Assistant base images. The minimum configured Home Assistant Core version is **2026.4.0**; use a current Supervisor as well.

The small, independent CI validates configuration and shell syntax and checks both image builds. The optional notification workflow keeps the main app repository up to date. See [pipeline notes](.github/README.md) to build on these pieces.

## Credits

Based on [Poeschl's Rsync Local add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local), with thanks for the original work. Maintained here by [Sebastian Schmidt (seb5594)](https://github.com/seb5594).

Licensed under the [Apache License 2.0](LICENCE).
