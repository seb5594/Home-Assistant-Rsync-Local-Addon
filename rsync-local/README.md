# Rsync Local

**Version 1.74**

![Version](https://img.shields.io/badge/version-1.74-167D8D?style=for-the-badge)

Keep an extra copy of **`/config`**, your Home Assistant configuration and secrets, plus important files from `/share`, `/media`, and other apps' exposed configuration folders.

Connect a USB stick, USB hard drive, or USB SSD directly to the Home Assistant server. Choose your folders and schedule regular runs with a Home Assistant automation. No NAS or cloud account is required.

Both `/app_configs` and `/addon_configs` work as source paths. Local apps can be copied from `/local_apps` or the older `/addons` path. These names are aliases, so select only one path for each set of files.

Each start runs one sync and exits. Default options mirror deletions; there is no encryption or version history. Keep Home Assistant's own backups for complete restores and consistent database data.

**[Configuration and scheduling](DOCS.md)** · **[Changelog](CHANGELOG.md)**

AMD64, AArch64, ARMv7, ARMhf, and i386 builds are included. A Supervisor with `all_addon_configs` mapping support is required; Core has no artificial version floor. The pinned packages come from Alpine Edge.

Based on [Poeschl's original add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local). Maintained by [seb5594](https://github.com/seb5594). Apache License 2.0.
