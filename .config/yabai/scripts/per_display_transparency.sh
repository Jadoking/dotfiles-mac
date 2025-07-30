#!/bin/bash

# Apps that should trigger transparency logic
apps_transparent="^(Spotify|Obsidian)$"

# Opacity values
opacity_active="0.80"
opacity_dim="0.00001"
opacity_normal="1.0"

script_dir="$(cd "$(dirname "$0")" && pwd)"
log_file="$script_dir/transparency.log"

# Get focused window info
focused_window=$(yabai -m query --windows --window)
focused_id=$(echo "$focused_window" | jq -r '.id')
focused_app=$(echo "$focused_window" | jq -r '.app' | tr -d '\n')
focused_display=$(echo "$focused_window" | jq -r '.display' | tr -d '\n')

echo "$(date) - Focused: $focused_app (ID $focused_id) on display $focused_display" >> "$log_file"

# Dim all other windows on a display except the given ID
# Does not check apps_transparent so expects that to be sorted out elsewhere
apply_transparency_to_display() {
  local display_index="$1"
  local top_id="$2"

  echo "Applying transparency to display $display_index (top window ID $top_id)" >> "$log_file"

  yabai -m window "$top_id" --opacity "$opacity_active"

  yabai -m query --windows | jq -c --argjson d "$display_index" --argjson top "$top_id" \
    '.[] | select(.display == $d and .id != $top and .layer == "normal")' | while read -r win; do
      id=$(echo "$win" | jq -r '.id')
      echo " → Dimming window ID $id on display $display_index" >> "$log_file"
      yabai -m window "$id" --opacity "$opacity_dim"
  done
}

# Reset a display to normal opacities
# TODO: I just learned about the has-focus attribute in the json so a rewrite using that attribute might not be bad
reset_display() {
  local display_index="$1"

  echo "Resetting display $display_index to normal opacities" >> "$log_file"

  yabai -m query --windows | jq -c --argjson d "$display_index" \
    '.[] | select(.display == $d and .layer == "normal")' | while read -r win; do
      id=$(echo "$win" | jq -r '.id')
      app=$(echo "$win" | jq -r '.app' | tr -d '\n')

      if [[ "$app" =~ $apps_transparent ]]; then
        opacity="$opacity_active"
      else
        opacity="$opacity_normal"
      fi

      echo " → Setting $app (ID $id) to opacity $opacity" >> "$log_file"
      yabai -m window "$id" --opacity "$opacity"
  done
}

if [[ "$focused_app" =~ $apps_transparent ]]; then
  apply_transparency_to_display "$focused_display" "$focused_id"
else
  reset_display "$focused_display"
fi
