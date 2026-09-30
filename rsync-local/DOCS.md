# Setup and Configuration

**Version 1.74**

Start here for the complete setup. The repository README is a short overview; this guide covers the USB drive, folder paths, options, scheduling, and recovery.

## 1. Prepare the drive

Use a partitioned, formatted USB stick, USB hard drive, or USB SSD with a filesystem supported by your Home Assistant OS installation. The app does not format drives.

A Linux filesystem such as ext4 is a good fit for `--archive`, which preserves ownership, permissions, and symbolic links. FAT/exFAT cannot preserve all Linux metadata; use suitable explicit options such as `--archive --no-owner --no-group --no-perms` and check the log and resulting files.

For a virtual machine, pass the USB storage device through to the Home Assistant OS guest.

Leave `external_device` empty and start the app. The log lists exposed candidate partitions without copying anything. Identify your USB partition, for example `/dev/sdb1`, and enter it in the options.

**Never assume `/dev/sda1` is the USB drive.** It might be your system disk. Device names can change after reconnecting drives. The app currently exposes partitions 1–5 on drives a–e.

## 2. Choose what to protect

**`/config` is the most important starting point.** It contains Home Assistant configuration, automations, scripts, dashboards, and `secrets.yaml`. It is a backup source, not the destination.

| Source path inside Rsync Local | Contents | Names and compatibility |
| --- | --- | --- |
| `/config` | Home Assistant configuration and secrets | Explicitly mounted read-only; unrelated to this app's private `/data`. |
| `/share` | Shared files and resources | Select the whole folder or a subfolder. |
| `/media` | Media, playlists, and other resources | Select the whole folder or a subfolder. |
| `/app_configs` | Other apps' exposed configuration folders | Alias of the `/addon_configs` mount. Current Supervisor supplies the renamed host configuration root. |
| `/addon_configs` | The same configuration files | Works on earlier Supervisors and current ones through the supported legacy mapping. |
| `/local_apps` | Locally developed app source folders | Alias of the `/addons` mount, whose host source follows the Supervisor's old/new local-app location. |
| `/addons` | The same local app/add-on files | The older container-facing name. |
| `/local_addons` | The same local app/add-on files | Convenience alias, not a claim about an official host directory name. |
| `/backup` | Existing Home Assistant backup archives | Does not create a fresh Home Assistant backup automatically. |
| `/ssl` | Certificates and private keys | Copies are unencrypted. |

These are **container-facing source paths**, not a raw view of the entire HAOS host root. Supervisor maps the matching host locations into the app. Other apps' private `/data` directories remain inaccessible.

The metadata uses `all_addon_configs:ro` and `addons:ro`: older names that current Supervisor also accepts for the renamed host folders. The app resolves its aliases before copying, so an alias produces real file copies rather than just a symbolic link on the USB drive.

A Supervisor supporting `all_addon_configs` is required; its schema is verified against **2023.11.0** and current rules. Older releases that do not recognize that mapping cannot install this configuration. There is no separate Core-version requirement.

## 3. Save your options

```yaml
folders:
  - source: /config
    options: --archive --prune-empty-dirs
  - source: /share
    options: --archive --prune-empty-dirs
  - source: /media
    options: --archive --prune-empty-dirs
  - source: /app_configs
    options: --archive --prune-empty-dirs
  - source: /local_apps
    options: --archive --prune-empty-dirs
external_folder: home-assistant
external_device: /dev/sdb1
```

Replace `/dev/sdb1` with your confirmed USB partition. This creates `home-assistant/config/`, `share/`, `media/`, `app_configs/`, and `local_apps/` on the drive.

The example deliberately omits `--delete`: source deletions are retained at the destination. Changed files still overwrite older copies; this is not historical snapshot storage.

### `folders[].source`

An absolute source directory inside one of the exposed roots. Subfolders are supported, for example `/share/voice-resources`. Trailing slashes are normalized.

Each source is copied into a destination folder bearing the selected source's final directory name. Two sources with the same final name are rejected before writing, because they would otherwise overwrite or delete each other's files.

Choose only one alias for each root, such as `/app_configs` rather than also selecting `/addon_configs`.

### `folders[].options` (optional)

Whitespace-separated rsync arguments. An explicit string replaces the default:

```text
--archive --delete --prune-empty-dirs
```

**`--delete` removes destination files absent from the matching source.** Omit it to retain such files.

Local copies no longer request compression; `--archive` already includes recursion. Custom options are still supported. Quoting inside the string is not interpreted, so prefer arguments whose values do not contain spaces.

For a smaller configuration copy without the live Recorder database or logs:

```yaml
source: /config
options: --archive --prune-empty-dirs --exclude=home-assistant_v2.db* --exclude=home-assistant.log*
```

This intentionally excludes the database. Use Home Assistant's own backups when you need it.

### `external_folder`

A relative destination path on the USB drive, such as `home-assistant` or `home-assistant/nightly`. Leading slashes, empty segments, `.`, and `..` segments are rejected. Existing destination symlinks must not escape the USB backup directory.

### `external_device`

The partition to mount, not the whole disk: `/dev/sdb1`, not `/dev/sdb`.

An empty value lists candidate partitions and exits without a sync. A configured partition must exist and be an exposed block device before copying starts.

## 4. Schedule regular copies

The app performs one run per start. Schedule it using Home Assistant, for example at 03:00:

```yaml
alias: Rsync Local - Nightly USB copy
description: Copy important Home Assistant files to the attached USB drive.
trigger:
  - platform: time
    at: "03:00:00"
action:
  - service: hassio.addon_start
    data:
      # Select the installed app in the editor or replace this ID.
      addon: YOUR_REPOSITORY_ID_rsync-local
mode: single
```

Select Rsync Local in the Supervisor start-app action to fill in the correct ID. The ID can also be found in the installed app's page URL.

Keep watchdog restart and automatic startup disabled for scheduled one-shot use. Leave enough time between runs for copying to finish: `mode: single` controls the automation, not the app's background work.

## Check and Restore

### Refresh the store or fix an old `:dev` image error

If installation/update still tries to download `ghcr.io/poeschl-homeassistant-addons/rsync-local-amd64:dev` and returns 404, Home Assistant is using obsolete store metadata. This fork builds locally from its Dockerfile; it does not use that upstream image.

In Home Assistant, open **Settings → Apps → App store → ⋮ → Check for updates**, then reopen Rsync Local. Older versions call these menus **Add-ons** and **Add-on store**. Alternatively, run this in a Home Assistant terminal:

```bash
ha store reload
```

Check the version offered in the app page before installing or updating. For `https://github.com/seb5594/Home-Assistant-Apps`, the repository ID is `4c7fee11` and the app ID is `4c7fee11_rsync-local`.

If refreshing still leaves obsolete `dev` metadata or repository Git errors, repair only this repository and refresh again:

```bash
ha store repair 4c7fee11
ha store reload
```

Repository repair reclones the catalog; it does not uninstall the app or erase your saved app options. There is no need to uninstall Rsync Local to refresh its store metadata.

New versions must first be published to the source repository's default branch and synchronized into the catalog. Repository maintainers can trigger synchronization with **Home-Assistant-Apps → Actions → Synchronize app catalog → Run workflow** on `main`. A Home Assistant store refresh cannot expose a version that is still only in a pull request.

### Verify and restore your copy

The log identifies each source and destination and reports elapsed time. Copy failures return a nonzero exit status. Cleanup attempts to stop an active transfer and unmount the drive on normal exit and handled errors/signals. A forced kill or hardware disconnection cannot guarantee cleanup.

Check the first copy and verify representative files before relying on the schedule. Restore needed files to their original location and follow Home Assistant's validation/restart procedure.

There is no built-in retention history, encryption, or application-aware database snapshot. Keep Home Assistant's native backups alongside this extra local copy.

Mounting requires `SYS_ADMIN`, and AppArmor is disabled. Source volumes are read-only; the USB destination is writable. Protect copies containing secrets and certificates.

## Runtime and Statistics

Version 1.74 uses a compact Alpine Edge runtime with **rsync 3.5.1-r0** and **coreutils 9.11-r1** pinned exactly. There is no S6, Bashio, web server, or resident scheduler. The process exits after copying and uses a lower CPU scheduling priority while rsync runs.

Edge is a rolling development branch. The base snapshot and requested package revisions are pinned, but dependency repositories still evolve. A missing pinned revision causes a build failure instead of a silent upgrade. All five architectures are checked with actual image builds and folder-copy tests.

GitHub badges show project/build activity, not Home Assistant installation counts. The app sends no telemetry. GitHub release-download totals would count attached release assets, not installations; this repository currently distributes local builds instead.
