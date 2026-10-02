# Rsync Local

![Version](https://img.shields.io/badge/version-1.74.2-167D8D?style=for-the-badge)
![Rsync](https://img.shields.io/badge/rsync-base%20repository-167D8D?style=for-the-badge)
![Coreutils](https://img.shields.io/badge/coreutils-base%20repository-167D8D?style=for-the-badge)

Back up **`/config`**, including your automations, dashboards, scripts, and `secrets.yaml`, to a USB stick, USB hard drive, or USB SSD attached directly to your Home Assistant server. Keep the important resources from `/share`, `/media`, and your app configuration folders alongside them.

A little extra peace of mind, right at home. No NAS or cloud account is required, and an existing NAS backup can happily remain part of your routine.

[![Add repository](https://img.shields.io/badge/Add-repository-41BDF5?logo=home-assistant&style=for-the-badge)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseb5594%2FHome-Assistant-Apps)

## Your folders, your schedule

| What matters | Source inside the app |
| --- | --- |
| **Home Assistant configuration and secrets** | **`/config`** |
| Shared files and media resources | `/share`, `/media` |
| Other apps' exposed configuration | `/app_configs` or `/addon_configs` |
| Locally developed apps/add-ons | `/local_apps` or `/addons` |
| Existing backup archives and certificates | `/backup`, `/ssl` |

The old and new configuration-folder names point to the same underlying files. Choose one name for each folder, not both.

**`/config` is a source to protect; the destination is your USB drive.** For example, its files are copied to `backup/config/` on that drive.

1. Install **Rsync Local** from the [Home Assistant Apps repository](https://github.com/seb5594/Home-Assistant-Apps).
2. Attach a prepared USB drive, select the correct partition, and choose your folders.
3. Run your first copy, check the log, then schedule regular runs with Home Assistant.

Each start performs one sync and exits. Later runs copy new and changed files. There is no background timer, extra web server, or installation telemetry.

**[Setup, options, and nightly automation](rsync-local/DOCS.md)** · **[Changelog](rsync-local/CHANGELOG.md)**

## Architectures and project activity

| Architecture | Measured image size |
| --- | --- |
| ![AMD64](https://img.shields.io/badge/amd64-supported-208447) | 16.8 MiB |
| ![AArch64](https://img.shields.io/badge/aarch64-supported-208447) | 19.9 MiB |
| ![ARMv7](https://img.shields.io/badge/armv7-legacy-64748B) | 12.1 MiB |
| ![ARMhf](https://img.shields.io/badge/armhf%20%28ARMv6%29-legacy-64748B) | 15.1 MiB |
| ![i386](https://img.shields.io/badge/i386-legacy-64748B) | 15.6 MiB |

Uncompressed Docker image sizes measured for version 1.74 on 2026-09-30, not download sizes. Rolling dependencies may change later build sizes; each build reports its own measurement.

[![Build checks](https://img.shields.io/github/actions/workflow/status/seb5594/Home-Assistant-Rsync-Local-Addon/checks.yml?branch=main&label=builds)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/actions/workflows/checks.yml)
[![Stars](https://img.shields.io/github/stars/seb5594/Home-Assistant-Rsync-Local-Addon?style=flat&label=stars)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/stargazers)
[![Issues](https://img.shields.io/github/issues/seb5594/Home-Assistant-Rsync-Local-Addon)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/issues)
[![Last commit](https://img.shields.io/github/last-commit/seb5594/Home-Assistant-Rsync-Local-Addon?label=updated)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/commits/main)
![License](https://img.shields.io/github/license/seb5594/Home-Assistant-Rsync-Local-Addon)

The 32-bit builds are for legacy installations; they do not restore official Home Assistant platform support. A Supervisor with `all_addon_configs` folder-mapping support is required (verified against **2023.11.0** and current mapping rules). No artificial Core-version minimum is configured.

The compact runtime installs rsync and coreutils from the selected Alpine base's configured repositories. Version 1.74.1 removes unavailable exact package revisions so local builds also work when Supervisor overrides `BUILD_FROM`. No Alpine branches are mixed. The default Alpine Edge base is a rolling development branch; actual installed versions are reported by the build checks.

There are no reliable public Home Assistant installation counts for this app. Local builds also do not produce measurable GitHub release downloads; project activity is shown instead of invented installation statistics.

## A sensible extra copy

The default options mirror deletions. Files removed from the source are removed from their corresponding USB destination folder too. There is no version history or encryption.

Keep Home Assistant's own backups for full restores and consistent database/application data. A running database is not safely backed up by an ordinary file copy. Protect the USB drive if it contains secrets.

## Credits

Based on [Poeschl's original Rsync Local add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local), with thanks for the original work. Maintained by [Sebastian Schmidt (seb5594)](https://github.com/seb5594).

[Apache License 2.0](LICENCE) · [Optional repository helpers](.github/README.md)
