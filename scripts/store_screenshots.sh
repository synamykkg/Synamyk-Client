#!/bin/bash
# Captures App Store screenshots: runs the integration test and grabs the
# simulator screen on each SHOT:<name> cue. Usage:
#   scripts/store_screenshots.sh <simulator-udid> <out-dir> <routes> <phone> <password>
set -u
SIM=$1; OUT=$2; ROUTES=$3; PHONE=$4; PASS=$5
mkdir -p "$OUT"
xcrun simctl status_bar "$SIM" override --time "9:41" --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3 --dataNetwork wifi
flutter test integration_test/store_screenshots_test.dart -d "$SIM" \
  --dart-define=SCREENSHOT_MODE=true --dart-define=SHOT_ROUTES="$ROUTES" \
  --dart-define=SHOT_PHONE="$PHONE" --dart-define=SHOT_PASSWORD="$PASS" \
  --dart-define=SHOT_GUEST="${SHOT_GUEST:-false}" 2>&1 |
while IFS= read -r line; do
  echo "$line"
  case "$line" in
    *SHOT:*) name=${line##*SHOT:}; xcrun simctl io "$SIM" screenshot "$OUT/$name.png" >/dev/null 2>&1 && echo "captured $name";;
  esac
done
