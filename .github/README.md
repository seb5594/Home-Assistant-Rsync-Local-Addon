# Repository helpers

## Immediate catalog updates

`workflows/notify-main.yml` notifies `seb5594/Home-Assistant-Apps` after a push to this repository's default branch. Manual execution is available too.

For immediate updates, configure the optional `PAT_TOKEN` secret with access to the main repository and **Contents: read and write** permission. Without it, the workflow reports a warning and the main repository's scheduled synchronization remains available.

## Dependency update proposals

`dependabot.yml` proposes monthly updates for GitHub Actions. Changes arrive as pull requests and are not automatically merged.

Neither helper collects installation statistics or reads your Home Assistant files.
