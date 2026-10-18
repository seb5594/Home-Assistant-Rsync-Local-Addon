<!-- header:begin (generated from project metadata) -->
<h1 align="center">Rsync Local</h1>

<p align="center">
  <img src="https://raw.githubusercontent.com/seb5594/Home-Assistant-Rsync-Local-Addon/main/rsync-local/logo.png" alt="Rsync Local" width="360" height="144">
</p>

---

<p align="center">
  <a href="https://paypal.me/seb5594"><img src="https://img.shields.io/static/v1?label=Support&amp;message=PayPal&amp;color=0070BA&amp;logo=paypal&amp;logoColor=white&amp;style=for-the-badge" alt="PayPal" height="40"></a>
  <a href="https://buymeacoffee.com/seb5594"><img src="https://img.shields.io/static/v1?label=Support&amp;message=Buy%20Me%20a%20Coffee&amp;color=FFDD00&amp;logo=buy-me-a-coffee&amp;logoColor=black&amp;style=for-the-badge" alt="Buy Me a Coffee" height="40"></a>
</p>

<p align="center">
  <a href="https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseb5594%2FHome-Assistant-Apps"><img src="https://img.shields.io/static/v1?label=Home%20Assistant&amp;message=Add%20app%20repository&amp;color=18BCF2&amp;logo=homeassistant&amp;logoColor=white&amp;style=for-the-badge" alt="Home Assistant" height="28"></a>
  <a href="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/releases/tag/v1.74.3"><img src="https://img.shields.io/static/v1?label=version&amp;message=1.74.3&amp;color=1877A5&amp;style=for-the-badge" alt="version" height="28"></a>
</p>

<p align="center">
  <a href="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/stargazers"><img src="https://img.shields.io/github/stars/seb5594/Home-Assistant-Rsync-Local-Addon?label=stars&amp;style=flat" alt="stars" height="20"></a>
  <a href="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/issues"><img src="https://img.shields.io/github/issues/seb5594/Home-Assistant-Rsync-Local-Addon?label=issues&amp;style=flat" alt="issues" height="20"></a>
  <a href="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/seb5594/Home-Assistant-Rsync-Local-Addon/ci.yml?branch=main&amp;label=checks&amp;style=flat" alt="checks" height="20"></a>
  <a href="https://github.com/seb5594/Home-Assistant-Rsync-Local-Addon#license"><img src="https://img.shields.io/github/license/seb5594/Home-Assistant-Rsync-Local-Addon?label=license&amp;style=flat" alt="license" height="20"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/static/v1?label=arch&amp;message=amd64%20%C2%B7%20aarch64%20%C2%B7%20armv7%20%C2%B7%20armhf%20%C2%B7%20i386&amp;color=157F71&amp;style=flat" alt="arch" height="20">
  <img src="https://img.shields.io/static/v1?label=mounts%20%28read-only%29&amp;message=app%20configs%20%C2%B7%20backup%20%C2%B7%20config%20%C2%B7%20local%20apps%20%C2%B7%20media%20%C2%B7%20share%20%C2%B7%20ssl&amp;color=157F71&amp;style=flat" alt="mounts (read-only)" height="20">
  <img src="https://img.shields.io/static/v1?label=local%20disks&amp;message=attached&amp;color=1877A5&amp;style=flat" alt="local disks" height="20">
  <img src="https://img.shields.io/static/v1?label=stage&amp;message=stable&amp;color=2F855A&amp;style=flat" alt="stage" height="20">
  <img src="https://img.shields.io/static/v1?label=privileged&amp;message=SYS_ADMIN&amp;color=B45309&amp;style=flat" alt="privileged" height="20">
  <img src="https://img.shields.io/static/v1?label=apparmor&amp;message=disabled&amp;color=B45309&amp;style=flat" alt="apparmor" height="20">
  <img src="https://img.shields.io/static/v1?label=options&amp;message=3&amp;color=1877A5&amp;style=flat" alt="options" height="20">
</p>
<!-- header:end -->

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

Architecture, mount, and capability badges come from `rsync-local/config.yaml`. Folders are mounted read-only; the app only reads them and writes to the attached drive. It has no ingress interface. Images are built for `amd64` and `aarch64` on the current Home Assistant base image and for `armv7`, `armhf` and `i386` on its previous generation.

Image size and runtime test count come from the CI build and are updated with every release run. The pull counter reads the public GHCR package page. None of these can count local builds, USB backups, or Home Assistant installations, and GitHub does not report download countries.

## Before you rely on a copy

Deleted source files are removed from their corresponding USB destination by the default mirror option. This is a file sync, with no built-in version history or encryption. Keep Home Assistant's own backups for full restores and consistent application/database data; copying a live database is not a safe database backup. Protect the USB drive when it contains secrets.

Based on [Poeschl's original Rsync Local add-on](https://github.com/Poeschl-HomeAssistant-Addons/rsync-local). Maintained by [seb5594](https://github.com/seb5594).

<!-- support:begin (generated, shared text) -->
## Say thanks

All my projects are built in my spare time, just for the fun of it. Still, they take a lot of time and care, and many of the smart home gadgets I buy end up here because I want to make them cloud-free and smart-home ready. Every bit of support means a lot to me.

If my work helped you or turned out to be useful, show your appreciation with a hot drink for my next sleepless night.

[![PayPal](https://img.shields.io/static/v1?label=Support&message=PayPal&color=0070BA&logo=paypal&logoColor=white&style=for-the-badge)](https://paypal.me/seb5594) [![Buy Me a Coffee](https://img.shields.io/static/v1?label=Support&message=Buy%20Me%20a%20Coffee&color=FFDD00&logo=buy-me-a-coffee&logoColor=black&style=for-the-badge)](https://buymeacoffee.com/seb5594)
<!-- support:end -->

<!-- license:begin (generated from the license file) -->
## License

[![license](https://img.shields.io/static/v1?label=license&message=Apache-2.0&color=5B6770&style=flat)](LICENSE)

Published under the [Apache License 2.0](LICENSE).
<!-- license:end -->
