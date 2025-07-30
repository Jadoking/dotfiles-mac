#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

APP_NAME="$INFO"
[ -z "$APP_NAME" ] && APP_NAME="App"

LABEL=$(sketchybar --query front_app.name | jq -r '.label.value')
TRACKER="${LABEL##* · }"
[[ "$TRACKER" == "$LABEL" ]] && TRACKER="あ｜い｜う｜え｜お"

sketchybar --set front_app.name label="$APP_NAME · $TRACKER"



