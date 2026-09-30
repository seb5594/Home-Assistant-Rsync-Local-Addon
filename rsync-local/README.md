# Rsync Local

![Version 1.73](https://img.shields.io/badge/version-1.73-167D8D?style=for-the-badge)

**Version 1.73**

Keep an extra copy of the Home Assistant files you would miss most: configurations, automations, secrets, and important resources from `/share` and `/media`.

Connect a USB stick, USB hard drive, or USB SSD directly to your Home Assistant server, choose your folders, and schedule regular runs with a Home Assistant automation. It is a simple additional backup destination at home, whether or not you already use a NAS.

Each start performs one rsync run and then exits. Later runs copy new and changed files. The default options mirror deletions too; this app does not provide version history or encryption.

For complete restores and consistent database backups, keep using Home Assistant's own backups alongside your local file copies.

**Architectures:** AMD64, AArch64, ARMv7, ARMhf (ARMv6), and i386. No artificial Home Assistant Core version floor is configured; a Supervisor-based installation is required. The 32-bit builds are provided for legacy installations, not as official Home Assistant platform support.

Read the [configuration and scheduling guide](DOCS.md) to get started.

Maintained by [seb5594](https://github.com/seb5594), based on [Poeschl's original Rsync Local add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local). Licensed under the Apache License 2.0.
