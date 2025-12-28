#!/usr/bin/env bash
set -e

RECORD_DIR="$HOME/Videos"
TS=$(date +%s)

MODE="$1" # area | output | stop

send_notification() {
    notify-send \
      "Screen recording" \
      "$1" \
      -t 2000 \
      -a Hyprrec
}

case "$MODE" in
  area)
    wf-recorder -g "$(slurp)" \
      -f "$RECORD_DIR/recording-area-$TS.mp4"
    ;;
  output)
    OUTPUT=$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')
    wf-recorder -o "$OUTPUT" \
      -f "$RECORD_DIR/recording-output-$TS.mp4"
    ;;
  stop)
    pkill -INT wf-recorder
    send_notification "Recording stopped"
    ;;
  *)
    exit 1
    ;;
esac
