#!/bin/bash

# Format local time
LOCAL_TIME=$(date '+%a %y/%m/%d %H:%M')

# Determine opposite timezone
CURRENT_TZ=$(date +%Z)
if [[ "$CURRENT_TZ" == "JST" || "$CURRENT_TZ" == "Japan" ]]; then
  OTHER_TIME=$(TZ="America/Los_Angeles" date '+%m/%d %H:%M')
  OTHER_LABEL="LA $OTHER_TIME"
else
  OTHER_TIME=$(TZ="Asia/Tokyo" date '+%m/%d %H:%M')
  OTHER_LABEL="JST $OTHER_TIME"
fi

# Combine into one label
LABEL="$LOCAL_TIME | $OTHER_LABEL"

# Apply to bar item
sketchybar --set "$NAME" label="$LABEL"

