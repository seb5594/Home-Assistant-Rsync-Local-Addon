# Repository automation

This repository keeps its automation small and independent. The application version is maintained in `rsync-local/config.yaml` and highlighted in both READMEs.

## Useful building blocks

| File | Purpose |
| --- | --- |
| `workflows/checks.yml` | Runs YAML and ShellCheck validation, checks version metadata, and builds all five architecture images (native AMD64/ARM64, emulated ARMv7/ARMhf, and 32-bit x86). It uses read-only repository permissions and does not publish images. |
| `workflows/notify-main.yml` | Signals `seb5594/Home-Assistant-Apps` after a push to this repository's default branch. Manual execution is also available. |
| `dependabot.yml` | Proposes monthly updates for GitHub Actions. Updates are reviewed through pull requests; nothing is automatically merged. |
| `../.yamllint` | Defines YAML formatting and duplicate-key checks used by CI. |
| `../.shellcheckrc` | Keeps the existing ShellCheck configuration used by CI. |

The notification workflow needs an optional `PAT_TOKEN` secret with access to `seb5594/Home-Assistant-Apps` and **Contents: read and write** permission. Without it, the workflow reports a warning; the main repository's scheduled synchronization still works.

No `UPDATER_TOKEN`, `DISPATCH_TOKEN`, or registry credential is needed for the remaining checks.

## Removed upstream automation

The inherited workflows called reusable workflows on the moving `main` branch of `Poeschl-HomeAssistant-Addons/workflows`. They were designed for that project's shared release infrastructure.

| Removed file | Reason |
| --- | --- |
| `addon-ci.yaml` | Its validation is useful, but the external wrapper is replaced by this repository's explicit checks and native image builds. |
| `addon-deploy.yaml` | The upstream deployment reads Poeschl's image catalog and dispatches updates to stable/edge repositories named `repository` and `repository-edge`. This project uses `Home-Assistant-Apps` and local builds. |
| `addon-main-push.yaml` | Automated release drafts are optional editorial tooling and are not required to deliver this app. |
| `addon-update-packages.yaml` | The upstream updater expects its own token and package-update conventions. Current builds install packages from the selected supported Alpine branch. |
| `labels.yaml`, `pr-labels.yaml`, `pr-title.yaml` | Shared label and pull-request naming policies do not affect installation, backup functionality, or build correctness. |
| `../.dive-ci.yaml`, `../.hadolint.yaml`, `../.markdownlint.yaml` | Their tools are no longer invoked by this project's CI, so these settings would be unused. |
| `../rsync-local/.README.j2` | Documentation is maintained directly as Markdown; no generated stable/edge README is needed. |

## Building your own publishing pipeline

Start with the existing checks and add publishing as a separate job or workflow:

1. Read the version from `rsync-local/config.yaml` and verify that a release tag matches it.
2. Build and test `linux/amd64`, `linux/arm64`, `linux/arm/v7`, `linux/arm/v6`, and `linux/386`. Preserve all five targets in the manifest if you publish one multi-architecture image.
3. Publish a multi-architecture image under your own GHCR namespace, tagged with that version.
4. Give only the publishing job `packages: write`; the built-in `GITHUB_TOKEN` can authenticate to your own registry.
5. Make the package publicly readable and verify that the versioned image can be pulled.
6. Enable the `image` field in the app configuration, pointing to your own image. Adjust the local-build assertion in `checks.yml`.
7. Update the main repository only after the versioned images are available. Move notification behind successful publishing at that point.

Keep the `image` field disabled until this is ready. Home Assistant currently builds version **1.73** from the Dockerfile in this repository.

The Dockerfile declares an architecture-dependent base-image default and Home Assistant labels directly. The active `build.yaml` selects the same images for legacy Supervisors. Newer Supervisors that no longer consume `build.yaml` resolve the Dockerfile default using `BUILD_ARCH`; CI tests that path without passing `BUILD_FROM`.

The official Alpine 3.22 release **2025.11.1** was the last base release to include all five architectures. It is pinned explicitly for consistent legacy builds. The 32-bit platforms are no longer maintained by Home Assistant; do not describe these builds as restoring official upstream support.

Metadata deliberately uses the older string-based `map` format and `host:container:rwm` device format. The latter is required by the Supervisor 2020.12.7 schema and is migrated by current Supervisors. `startup: application` is explicit because it was required by older schemas. `io.hass.type=addon` also retains the original label convention.

No `homeassistant` version constraint is configured: this file-copy tool has no Core API dependency. The newer `all_addon_configs` mapping is disabled so older Supervisors do not reject the configuration. A modern CI runner does not impose a minimum version on the user's Home Assistant installation.

When updating the app version, update the bold version line and badge in both READMEs and the Dockerfile's standalone `BUILD_VERSION` default. Home Assistant and CI pass the authoritative version from `config.yaml` as a build argument.
