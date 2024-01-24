#!/bin/bash

export PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

if [ "$SENDER" = "space_windows_change" ]; then
  args=(--animate sin 10)

  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $($PLUGIN_DIR/spaces/scripts/icon_map.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi
  args+=(--set space.$space label="$icon_strip")

  sketchybar -m "${args[@]}"
fi