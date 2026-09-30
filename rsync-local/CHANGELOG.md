# Changelog

## 1.74.1

- Fix local Docker builds failing on unavailable rsync/coreutils package revisions.
- Resolve both packages from the selected Alpine base instead of pinning missing revisions.
- Keep package repositories aligned with the base, including Supervisor BUILD_FROM overrides.
- Verify package availability and report the actual installed versions in build checks.
- Restore the main catalog to root project submodules without a `.sources` directory.

## 1.74

### Added

- Back up other apps' exposed configuration using either `/app_configs` or `/addon_configs`.
- Back up locally developed apps using `/local_apps`, `/addons`, or the convenience alias `/local_addons`.
- Store-visible changelog, a complete setup guide, and individual architecture/project badges.
- Store refresh and targeted repository-repair instructions for obsolete upstream `:dev` image errors.
- Runtime checks for invalid devices, unsafe destination paths, missing sources, and colliding destination names.
- Automatic unmount attempts on completion, copy errors, and handled stop signals.
- Real folder-copy and failure-path tests in the five-architecture build checks.

### Changed

- Pin rsync to **3.5.1-r0** and Coreutils to **9.11-r1**.
- Use a smaller Alpine Edge runtime without S6 or Bashio.
- Remove redundant recursion/compression options from the default local-copy arguments.
- Lower rsync CPU scheduling priority to reduce contention with Home Assistant.
- Keep the repository README focused on users; place detailed setup in `DOCS.md`.
- Remove obsolete commented replacements while keeping concise safety/compatibility explanations.

### Compatibility and Safety

- App version increases from 1.73 to **1.74**.
- All five architectures remain included; 32-bit platforms are legacy builds.
- A Supervisor with `all_addon_configs` mapping support is now required (schema verified against 2023.11.0); there is still no artificial Core-version floor.
- Existing explicit rsync options continue to apply unchanged.
- Destination folders remain named after the configured source directory. Missing sources and duplicate names now fail before copying.
- Default `--delete` behavior is unchanged. There is still no encryption, version history, or automatic Home Assistant database snapshot.
- Alpine Edge is used for the requested package versions; pinned revisions must remain available to build.

## 1.73

- Prepare the fork for the local USB-backup use case.
- Add a direct repository notification workflow and independent build checks.
- Restore AMD64, AArch64, ARMv7, ARMhf, and i386 build targets.
- Remove the artificial Core-version floor and restore legacy folder/device metadata.
- Document configuration, scheduling, restore limitations, and upstream credits.

Earlier upstream releases are not reconstructed here; this changelog records the changes made in this fork.
