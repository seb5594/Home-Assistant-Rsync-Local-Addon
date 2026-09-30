# Configuration and scheduling

**Version 1.73**

Rsync Local copies selected folders onto a USB storage device attached directly to the Home Assistant server. It mounts the configured partition, runs rsync for each source, unmounts the device after a successful run, and exits.

## Prepare your USB drive

Use an already partitioned and formatted drive with a filesystem supported by your Home Assistant OS installation. This app does not partition or format devices.

For a Home Assistant OS virtual machine, pass the USB storage device through to the guest first.

1. Leave `external_device` empty and start the app.
2. Look at the device list in the app log.
3. Identify your external drive's partition and enter its path, for example `/dev/sdb1`.
4. Save the options and start the app again.

**An empty device setting lists candidates without copying anything.** There is no automatic selection of `/dev/sda1`. Always identify the USB drive; a listed device might belong to your system disk. Device names can change after reconnecting drives.

## Example configuration

```yaml
folders:
  - source: /config
    options: --archive --prune-empty-dirs
  - source: /share
    options: --archive --prune-empty-dirs
  - source: /media
    options: --archive --prune-empty-dirs
external_folder: home-assistant
external_device: /dev/sdb1
```

Replace `/dev/sdb1` with your confirmed USB partition.

This example keeps `config`, `share`, and `media` as separate folders inside `home-assistant` on the USB drive. Its explicit options omit `--delete`: files removed from the source are kept at the destination, but changed files still overwrite previous copies. This does not create historical snapshots.

### `folders`

The list of folders to copy. Choose full folders or smaller paths such as `/share/voice-resources` or `/media/playlists`.

Available source roots are `/config`, `/share`, `/media`, `/backup`, `/addons`, `/ssl`. They are mounted read-only because this app only needs to read source files. Other apps' private `/data` directories are not exposed. The newer `/addon_configs` mapping is deliberately omitted because very old Supervisors do not recognize it; use Home Assistant's own backups for other apps' data and configuration.

### `folders[].source`

The path inside the app container. Use an absolute directory path **without a trailing slash** to retain the source directory's name on the destination.

Avoid two source directories with the same final name: they would share a destination folder.

### `folders[].options` (optional)

A whitespace-separated string of rsync options. When supplied, it replaces the entire default set:

```text
--archive --recursive --compress --delete --prune-empty-dirs
```

**The default `--delete` removes destination files that no longer exist in the corresponding source folder.** Use explicit options without `--delete` if you want to keep such files.

The app splits this string into arguments; shell-style quoting inside it is not interpreted. Prefer options that do not require values containing spaces.

### `external_folder`

The destination folder on the USB drive, for example `home-assistant`. Use a simple relative folder name without a leading slash or `..` path segments.

Source directories are copied beneath this folder. Nothing is automatically encrypted or archived into a Home Assistant backup file.

### `external_device`

The USB partition to mount. Currently exposed device paths are `/dev/sda1` through `/dev/sde5` (partitions 1–5 for drives a–e).

Use the partition path, such as `/dev/sdb1`, rather than the whole-disk path `/dev/sdb`. An empty string lists candidate devices and performs no sync.

## Run every night

The app runs once each time it is started. To run it every night at 03:00, create a Home Assistant automation:

```yaml
alias: Rsync Local - Nightly USB copy
description: Copy selected Home Assistant files to the attached USB drive.
# Replaced: triggers:
trigger:
  # Replaced: - trigger: time
  - platform: time
    at: "03:00:00"
# Replaced: actions:
action:
  # Replaced: - action: hassio.addon_start
  - service: hassio.addon_start
    data:
      # Replace this with the full ID of your installed Rsync Local app.
      addon: YOUR_REPOSITORY_ID_rsync-local
mode: single
```

Replace the placeholder with the installed app ID. You can select **Rsync Local** in the automation editor's **Home Assistant Supervisor: Start app/add-on** action, or find its ID in the app page URL.

Leave automatic startup and watchdog restart disabled for this one-run workflow. Choose intervals long enough for each copy to finish; `mode: single` does not wait for the app's copy process to complete.

## Restore and check your copies

The copied files can be inspected on the USB drive. Restore the files you need to their original locations and follow Home Assistant's usual validation and restart procedure.

Use Home Assistant's own backup feature for full restores and consistent database or application backups. Copying files from a running database is not a substitute for an application-aware backup.

The app needs `SYS_ADMIN` and has AppArmor disabled to mount storage. Copied secrets and certificates are unencrypted; protect the USB drive accordingly.

Check the log after the first run and after changing devices. A failed copy is not a completed backup.
