# Rsync Local

<!-- badges:begin (generated from project metadata) -->
[![Version](https://img.shields.io/badge/version-1.74.3-1877A5?style=for-the-badge)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/releases)
[![CI](https://img.shields.io/github/actions/workflow/status/seb5594/Home-Assistant-Rsync-Local-Addon/ci.yml?branch=main&label=builds)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/actions/workflows/ci.yml)
[![Release asset downloads](https://img.shields.io/github/downloads/seb5594/Home-Assistant-Rsync-Local-Addon/total?label=release%20downloads)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/releases)
[![Stars](https://img.shields.io/github/stars/seb5594/Home-Assistant-Rsync-Local-Addon?label=stars)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/seb5594/Home-Assistant-Rsync-Local-Addon?label=updated)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/commits/main)

![armhf](https://img.shields.io/badge/armhf-supported-157F71?style=flat-square) ![armv7](https://img.shields.io/badge/armv7-supported-157F71?style=flat-square) ![aarch64](https://img.shields.io/badge/aarch64-supported-157F71?style=flat-square) ![amd64](https://img.shields.io/badge/amd64-supported-157F71?style=flat-square) ![i386](https://img.shields.io/badge/i386-supported-157F71?style=flat-square)
![stage](https://img.shields.io/badge/stage-stable-2F855A?style=flat-square) ![mount](https://img.shields.io/badge/mount-config-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-share-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-media-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-backup-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-ssl-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-local%20apps-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-app%20configs-157F71?style=flat-square) ![mount](https://img.shields.io/badge/mount-local%20disks-157F71?style=flat-square)

[![Add to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseb5594%2FHome-Assistant-Apps)
[![Buy Me a Coffee](https://img.shields.io/badge/Support-Buy%20Me%20a%20Coffee-FFDD00?logo=buy-me-a-coffee&logoColor=black&style=for-the-badge)](https://buymeacoffee.com/seb5594)
[![PayPal](https://img.shields.io/badge/Support-PayPal-0070BA?logo=paypal&logoColor=white&style=for-the-badge)](https://www.paypal.com/donate/?hosted_button_id=QMQPNRENXDN26)
<!-- badges:end -->

Keep a second copy of the Home Assistant files that matter most on a USB stick, hard drive, or SSD plugged directly into your server. **`/config`** contains your automations, dashboards, scripts, and secrets; share, media, and app configuration folders can join the same scheduled backup.

This is an extra in-house safety net alongside Home Assistant's own backups. You do not need a NAS or a cloud account.

## Choose the folders you value

| Content | Source inside the app |
| --- | --- |
| **Home Assistant configuration and secrets** | **`/config`** |
| Shared files and media | `/share`, `/media` |
| Other apps' exposed configurations | `/app_configs` or `/addon_configs` |
| Locally developed apps | `/local_apps` or `/addons` |
| Existing backup archives and certificates | `/backup`, `/ssl` |

Choose only one name for each aliased folder. `/config` is a **source**; your attached USB drive is the destination, for example `backup/config/`.

1. [Add the app catalog to Home Assistant](https://github.com/seb5594/Home-Assistant-Apps), then install Rsync Local.
2. Select the USB partition and source folders; run your first copy and inspect the log.
3. Schedule regular runs through a Home Assistant automation.

Each start syncs files once and exits. Subsequent runs copy changes. There is no background timer or installation telemetry.

**[Setup, all options, and a scheduled automation](DOCS.md)** · **[Changelog](rsync-local/CHANGELOG.md)** · **[Releases and image references](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/releases)**

## What the badges mean

Architecture and mount badges come from `rsync-local/config.yaml`. The app exposes local disks and deliberately has no ingress interface. The five architecture builds include legacy `armhf`, `armv7`, and `i386`; those builds do not extend official Home Assistant platform support. The GitHub download badge counts **release assets only**. It cannot count GHCR pulls, local builds, USB backups, or Home Assistant installations; GitHub does not report download countries.

Previous version 1.74 image-size measurements, which are not download sizes: amd64 16.8 MiB, aarch64 19.9 MiB, armv7 12.1 MiB, armhf 15.1 MiB, i386 15.6 MiB. Newer bases and dependency updates change these values.

## Before you rely on a copy

Deleted source files are removed from their corresponding USB destination by the default mirror option. This is a file sync, with no built-in version history or encryption. Keep Home Assistant's own backups for full restores and consistent application/database data; copying a live database is not a safe database backup. Protect the USB drive when it contains secrets.

Based on [Poeschl's original Rsync Local add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local). Maintained by [Sebastian Schmidt](https://github.com/seb5594). [Apache License 2.0](LICENCE).
