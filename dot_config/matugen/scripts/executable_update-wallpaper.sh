#!/usr/bin/env bash
set -e
CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"
TMP_FILE="${CONFIG_FILE}.tmp.$$"
WALLPAPER_PATH="$1"

python3 -c "
import json, sys
path = sys.argv[1]
with open('${CONFIG_FILE}') as f:
    data = json.load(f)
data.setdefault('background', {})
data['background']['wallpaperPath'] = path
with open('${TMP_FILE}', 'w') as f:
    json.dump(data, f, indent=4)
" "$WALLPAPER_PATH"

mv "$TMP_FILE" "$CONFIG_FILE"
