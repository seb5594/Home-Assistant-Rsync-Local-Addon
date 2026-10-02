# Rsync Local

<!-- badges:begin (generated from project metadata) -->
[![version](https://img.shields.io/static/v1?label=version&message=1.74.4&color=1877A5&style=flat)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/releases) [![released](https://img.shields.io/github/release-date-pre/seb5594/Home-Assistant-Rsync-Local-Addon?label=released&style=flat)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/releases) [![build](https://img.shields.io/github/actions/workflow/status/seb5594/Home-Assistant-Rsync-Local-Addon/ci.yml?branch=main&label=build&style=flat)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/actions/workflows/ci.yml)<br>
[![stars](https://img.shields.io/github/stars/seb5594/Home-Assistant-Rsync-Local-Addon?label=stars&style=flat)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/stargazers) [![issues](https://img.shields.io/github/issues/seb5594/Home-Assistant-Rsync-Local-Addon?label=issues&style=flat)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/issues) [![updated](https://img.shields.io/github/last-commit/seb5594/Home-Assistant-Rsync-Local-Addon?label=updated&style=flat)](https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/commits/main) ![image pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseb5594%2FHome-Assistant-Rsync-Local-Addon%2Fbadges%2Fimage-pulls.json&style=flat)<br>
![arch](https://img.shields.io/static/v1?label=arch&message=armhf&color=157F71&style=flat) ![arch](https://img.shields.io/static/v1?label=arch&message=armv7&color=157F71&style=flat) ![arch](https://img.shields.io/static/v1?label=arch&message=aarch64&color=157F71&style=flat) ![arch](https://img.shields.io/static/v1?label=arch&message=amd64&color=157F71&style=flat) ![arch](https://img.shields.io/static/v1?label=arch&message=i386&color=157F71&style=flat)<br>
![read-only](https://img.shields.io/static/v1?label=read-only&message=config%20%C2%B7%20share%20%C2%B7%20media%20%C2%B7%20backup%20%C2%B7%20ssl%20%C2%B7%20local%20apps%20%C2%B7%20app%20configs&color=157F71&style=flat) ![local disks](https://img.shields.io/static/v1?label=local%20disks&message=attached&color=1877A5&style=flat)<br>
![stage](https://img.shields.io/static/v1?label=stage&message=stable&color=2F855A&style=flat) ![privileged](https://img.shields.io/static/v1?label=privileged&message=SYS_ADMIN&color=B45309&style=flat) ![apparmor](https://img.shields.io/static/v1?label=apparmor&message=disabled&color=B45309&style=flat) ![options](https://img.shields.io/static/v1?label=options&message=3&color=1877A5&style=flat)<br>
![image size](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseb5594%2FHome-Assistant-Rsync-Local-Addon%2Fbadges%2Fimage-size.json&style=flat) ![runtime tests](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseb5594%2FHome-Assistant-Rsync-Local-Addon%2Fbadges%2Fruntime-tests.json&style=flat) ![last build](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseb5594%2FHome-Assistant-Rsync-Local-Addon%2Fbadges%2Flast-build.json&style=flat)<br>
[![Home Assistant](https://img.shields.io/static/v1?label=Home%20Assistant&message=Add%20app%20repository&color=18BCF2&style=flat&logo=homeassistant&logoColor=white)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseb5594%2FHome-Assistant-Apps)<br>
[![Buy Me a Coffee](https://img.shields.io/static/v1?label=Support&message=Buy%20Me%20a%20Coffee&color=FFDD00&logo=buy-me-a-coffee&logoColor=black&style=flat)](https://buymeacoffee.com/seb5594) [![PayPal](https://img.shields.io/static/v1?label=Support&message=PayPal&color=0070BA&logo=paypal&logoColor=white&style=flat)](https://www.paypal.com/donate/?hosted_button_id=QMQPNRENXDN26)
<!-- badges:end -->

Rsync Local is a Home Assistant app that backs up the source folders you configure, such as `/config`, `/share` or `/media`, to a USB drive attached to your Home Assistant host. It copies with rsync, runs once per start and exits, so a Home Assistant automation can schedule it. The folders are mounted read-only; files you delete at the source are removed from the drive on the next run unless you change the rsync options.

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

Architecture, mount, and capability badges come from `rsync-local/config.yaml`. Folders are mounted read-only; the app only reads them and writes to the attached drive. It has no ingress interface. The five architecture builds include legacy `armhf`, `armv7`, and `i386`; those builds do not extend official Home Assistant platform support.

Image size, runtime test count, and the last build date are published by the CI pipeline after each release. The pull counter reads the public GHCR package page. None of these can count local builds, USB backups, or Home Assistant installations, and GitHub does not report download countries.

## Before you rely on a copy

Deleted source files are removed from their corresponding USB destination by the default mirror option. This is a file sync, with no built-in version history or encryption. Keep Home Assistant's own backups for full restores and consistent application/database data; copying a live database is not a safe database backup. Protect the USB drive when it contains secrets.

Based on [Poeschl's original Rsync Local add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local). Maintained by [seb5594](https://github.com/seb5594). [Apache License 2.0](LICENSE).
