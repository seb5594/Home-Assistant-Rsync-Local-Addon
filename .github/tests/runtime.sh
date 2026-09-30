#!/usr/bin/env bash
set -Eeuo pipefail

# Use the image's actual rsync; mock only hardware mounting and device checks.
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
passed=0

setup() {
  local scenario=$1
  # shellcheck source=rsync-local/root/run.sh
  source "${RUN_SCRIPT:-/run.sh}"
  CASE_ROOT="$fixture/$scenario"
  mkdir -p "$CASE_ROOT"/{config,share,addons,addon_configs,usb,outside}
  printf 'secret\n' > "$CASE_ROOT/config/secrets.yaml"
  printf 'app settings\n' > "$CASE_ROOT/addon_configs/options.json"
  printf 'local code\n' > "$CASE_ROOT/addons/config.yaml"
  ln -s "$CASE_ROOT/addon_configs" "$CASE_ROOT/app_configs"
  ln -s "$CASE_ROOT/addons" "$CASE_ROOT/local_apps"
  OPTIONS_FILE="$CASE_ROOT/options.json"
  MOUNT_POINT="$CASE_ROOT/usb"
  SOURCE_ROOTS=("$CASE_ROOT/config" "$CASE_ROOT/share" "$CASE_ROOT/addons" "$CASE_ROOT/addon_configs")
  mount() { printf 'mount\n' >> "$CASE_ROOT/events"; }
  umount() { printf 'umount\n' >> "$CASE_ROOT/events"; }
  validate_device() { [[ $1 == /dev/sdb1 ]]; }
  jq -n --arg source "$CASE_ROOT/config" \
    '{folders: [{source: $source}], external_folder: "backup", external_device: "/dev/sdb1"}' > "$OPTIONS_FILE"
}

change_options() {
  jq "$@" "$OPTIONS_FILE" > "$CASE_ROOT/changed.json"
  mv "$CASE_ROOT/changed.json" "$OPTIONS_FILE"
}

scenario() {
  local name=$1
  setup "$name"
  case $name in
    aliases)
      # shellcheck disable=SC2016
      change_options --arg configs "$CASE_ROOT/app_configs" --arg apps "$CASE_ROOT/local_apps" \
        '.folders += [{source: $configs}, {source: $apps}]'
      ;;
    mirror|preserve)
      mkdir -p "$MOUNT_POINT/backup/config"
      printf 'old\n' > "$MOUNT_POINT/backup/config/removed.txt"
      if [[ $name == preserve ]]; then change_options '.folders[0].options = "--archive"'; fi
      ;;
    missing) change_options '.folders[0].source += "/missing"' ;;
    collision) change_options '.folders += [.folders[0]]' ;;
    traversal) change_options '.external_folder = "../outside"' ;;
    unavailable) change_options '.external_device = "/dev/sdz1"' ;;
    empty) change_options '.external_device = ""' ;;
    mount_failure) mount() { return 1; } ;;
    destination_escape)
      ln -s "$CASE_ROOT/outside" "$MOUNT_POINT/backup"
      ;;
    copy_failure)
      change_options '.folders[0].options = "--this-option-does-not-exist"'
      ;;
    unmount_failure)
      umount() { printf 'umount\n' >> "$CASE_ROOT/events"; return 1; }
      ;;
  esac
  main
}

run_case() {
  local name=$1 expected=$2 status=0 root="$fixture/$1"
  set +e
  (set -Eeuo pipefail; scenario "$name") > "$fixture/$name.log" 2>&1
  status=$?
  set -e
  if [[ $status != "$expected" ]]; then
    printf 'FAIL: %s (status %s, expected %s)\n' "$name" "$status" "$expected"
    cat "$fixture/$name.log"
    exit 1
  fi
  case $name in
    aliases)
      cmp "$root/config/secrets.yaml" "$root/usb/backup/config/secrets.yaml"
      cmp "$root/addon_configs/options.json" "$root/usb/backup/app_configs/options.json"
      cmp "$root/addons/config.yaml" "$root/usb/backup/local_apps/config.yaml"
      test ! -L "$root/usb/backup/app_configs"
      ;;
    mirror) test ! -e "$root/usb/backup/config/removed.txt" ;;
    preserve) test -f "$root/usb/backup/config/removed.txt" ;;
    missing|collision|traversal|unavailable|empty|mount_failure)
      test ! -e "$root/events"
      test ! -e "$root/usb/backup/config/secrets.yaml"
      ;;
    destination_escape) test ! -e "$root/outside/config" ;;
  esac
  case $name in
    aliases|mirror|preserve|destination_escape|copy_failure|unmount_failure)
      test "$(< "$root/events")" = $'mount\numount'
      ;;
  esac
  passed=$((passed + 1))
  printf 'PASS: %s\n' "$name"
}

run_case aliases 0
run_case mirror 0
run_case preserve 0
run_case missing 1
run_case collision 1
run_case traversal 1
run_case unavailable 1
run_case empty 0
run_case mount_failure 1
run_case destination_escape 1
run_case copy_failure 1
run_case unmount_failure 1
printf '%s runtime scenarios passed.\n' "$passed"
