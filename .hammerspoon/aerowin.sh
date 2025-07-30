#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

target_app="$1"
if [ -z "$target_app" ]; then
  echo "Usage: $0 <app name>"
  exit 1
fi

current_workspace=$(aerospace list-workspaces --focused)
if [ -z "$current_workspace" ]; then
  echo "Could not determine current workspace"
  exit 1
fi

echo "Current workspace: $current_workspace"

focus_app_in_workspace() {
  local workspace="$1"

  window_id=$(aerospace list-windows --workspace "$workspace" | awk -F'|' -v app="$target_app" '
    $2 ~ app { gsub(/ /, "", $1); print $1; exit }
  ')

  if [ -n "$window_id" ]; then
    echo "Focusing '$target_app' in workspace $workspace (window ID: $window_id)"
    if [ "$workspace" != "$current_workspace" ]; then
      aerospace workspace "$workspace"
      sleep 0.1  
    fi
    aerospace focus --window-id "$window_id"
    return 0
  fi

  return 1
}

if focus_app_in_workspace "$current_workspace"; then
  exit 0
fi

mapfile -t all_workspaces < <(aerospace list-workspaces --all)

for workspace in "${all_workspaces[@]}"; do
  if [[ "$workspace" != "$current_workspace" ]]; then
    if focus_app_in_workspace "$workspace"; then
      exit 0
    fi
  fi
done

echo "'$target_app' not found in any workspace. Launching."
open -a "$target_app"

