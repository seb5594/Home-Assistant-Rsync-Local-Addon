# Repository automation

This repository keeps its automation small and independent. The application version is maintained in `rsync-local/config.yaml` and highlighted in both READMEs.

## Useful building blocks

| File | Purpose |
| --- | --- |
| `workflows/checks.yml` | Runs YAML and ShellCheck validation, checks version metadata, and builds native AMD64 and ARM64 images. It uses read-only repository permissions and does not publish images. |
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
2. Build and test both `linux/amd64` and `linux/arm64` images.
3. Publish a multi-architecture image under your own GHCR namespace, tagged with that version.
4. Give only the publishing job `packages: write`; the built-in `GITHUB_TOKEN` can authenticate to your own registry.
5. Make the package publicly readable and verify that the versioned image can be pulled.
6. Enable the `image` field in the app configuration, pointing to your own image. Adjust the local-build assertion in `checks.yml`.
7. Update the main repository only after the versioned images are available. Move notification behind successful publishing at that point.

Keep the `image` field disabled until this is ready. Home Assistant currently builds version **1.73** from the Dockerfile in this repository.

The Dockerfile declares its base image and Home Assistant labels directly. The old `build.yaml` is retained as a clearly disabled, commented reference for the former settings; current Supervisor does not consume it.

When updating the app version, update the bold version line and badge in both READMEs and the Dockerfile's standalone `BUILD_VERSION` default. Home Assistant and CI pass the authoritative version from `config.yaml` as a build argument.
