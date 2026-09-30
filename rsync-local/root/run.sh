#!/usr/bin/env bash
set -Eeuo pipefail

OPTIONS_FILE=/data/options.json
MOUNT_POINT=/external
SOURCE_ROOTS=(/config /share /media /backup /addons /ssl /addon_configs)
DEFAULT_OPTIONS="--archive --delete --prune-empty-dirs"
mounted=false
child_pid=""

log() { printf '[%s] %s\n' "$1" "$2"; }
die() { log ERROR "$*" >&2; exit 1; }

cleanup() {
  local status=$?
  trap - EXIT INT TERM
  if [[ -n $child_pid ]]; then
    kill "$child_pid" 2>/dev/null || true
    wait "$child_pid" 2>/dev/null || true
  fi
  if [[ $mounted == true ]] && ! umount "$MOUNT_POINT"; then
    log ERROR "Could not unmount the USB drive. Check the device before unplugging it." >&2
    status=1
  fi
  exit "$status"
}

resolve_source() {
  local path root
  path=$(realpath -e -- "$1") || return 1
  [[ -d $path ]] || return 1
  for root in "${SOURCE_ROOTS[@]}"; do
    if [[ $path == "$root" || $path == "$root/"* ]]; then
      printf '%s\n' "$path"
      return 0
    fi
  done
  return 1
}

validate_device() {
  [[ $1 =~ ^/dev/sd[a-e][1-5]$ && -b $1 ]]
}

list_devices() {
  local devices=()
  shopt -s nullglob
  devices=(/dev/sd[a-e][1-5])
  shopt -u nullglob
  if (( ${#devices[@]} )); then
    printf '%s\n' "${devices[@]}"
  else
    log INFO "No exposed USB partitions found."
  fi
  log INFO "Set external_device to your confirmed USB partition, then start the app again."
}

main() {
  local device folder count index source name destination root options elapsed
  local -a sources=() paths=() option_strings=() args=()
  local -A destinations=()
  mounted=false
  child_pid=""

  jq -e '
    (.folders | type == "array" and length > 0) and
    all(.folders[];
      (.source | type == "string" and startswith("/") and (test("[\\r\\n]") | not)) and
      ((.options // "") | type == "string" and (test("[\\r\\n]") | not))) and
    (.external_folder | type == "string" and length > 0) and
    ((.external_device // "") | type == "string")
  ' "$OPTIONS_FILE" >/dev/null || die "Invalid configuration."

  device=$(jq -r '.external_device // ""' "$OPTIONS_FILE")
  if [[ -z $device ]]; then
    list_devices
    return 0
  fi
  validate_device "$device" || die "USB partition is unavailable or not exposed: $device"

  folder=$(jq -r '.external_folder' "$OPTIONS_FILE")
  [[ $folder != /* && $folder != *$'\n'* && $folder != *$'\r'* ]] ||
    die "external_folder must be a relative path."
  case "/$folder/" in
    */../*|*/./*|*//*)
      die "external_folder must not contain empty, '.' or '..' path segments."
      ;;
  esac

  # Validate all sources before mounting or changing any destination files.
  mapfile -t sources < <(jq -r '.folders[].source' "$OPTIONS_FILE")
  mapfile -t option_strings < <(jq -r --arg defaults "$DEFAULT_OPTIONS" '.folders[] | .options // $defaults' "$OPTIONS_FILE")
  count=${#sources[@]}
  for ((index=0; index<count; index++)); do
    source=$(resolve_source "${sources[index]}") ||
      die "Source is missing or outside the exposed folders: ${sources[index]}"
    paths+=("$source")
    name=$(basename -- "${sources[index]%/}")
    [[ $name != . && $name != .. && -n $name ]] || die "Invalid source directory name."
    [[ -z ${destinations[$name]+present} ]] || die "Two sources would share destination folder '$name'."
    destinations["$name"]=1
  done

  trap cleanup EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  mkdir -p -- "$MOUNT_POINT"
  mount "$device" "$MOUNT_POINT" || die "Could not mount $device."
  mounted=true
  root=$(realpath -m -- "$MOUNT_POINT/$folder")
  [[ $root == "$MOUNT_POINT/"* ]] || die "Destination escapes the USB mount."
  mkdir -p -- "$root"
  elapsed=$SECONDS

  for ((index=0; index<count; index++)); do
    source=${paths[index]}
    name=$(basename -- "${sources[index]%/}")
    destination=$(realpath -m -- "$root/$name")
    [[ $destination == "$root/"* ]] || die "Destination '$name' escapes the backup folder."
    mkdir -p -- "$destination"
    options=${option_strings[index]}
    read -r -a args <<< "$options"
    log INFO "Copying ${sources[index]} to $folder/$name"
    # Resolving directory aliases avoids archiving only a symlink instead of its files.
    nice -n 10 rsync "${args[@]}" -- "$source/" "$destination/" &
    child_pid=$!
    if ! wait "$child_pid"; then
      child_pid=""
      die "Copy failed for ${sources[index]}; check the rsync output."
    fi
    child_pid=""
  done

  log INFO "Copied $count folders in $((SECONDS - elapsed)) seconds."
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  main "$@"
fi
