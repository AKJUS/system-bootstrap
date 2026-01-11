#!/usr/bin/env bash

RECORD_DIR="$HOME/Videos"
PIDFILE="/tmp/hyprrec.pid"
TS=$(date +%s)

MODE="$1" # area | output | stop
mkdir -p "$RECORD_DIR"

notify() {
  notify-send "Screen recording" "$1" -t 2000 -a Hyprrec
}

start() {
  "$@" &
  echo $! > "$PIDFILE"
  notify "Recording started"
}

stop() {
  [ -f "$PIDFILE" ] || exit 0
  kill -INT "$(cat "$PIDFILE")"
  rm -f "$PIDFILE"
  notify "Recording stopped"
}

case "$MODE" in
  area)
    GEOM=$(slurp) || exit 0
    start wf-recorder -g "$GEOM" \
      -f "$RECORD_DIR/recording-area-$TS.mp4"
    ;;
  output)
    OUTPUT=$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')
    start wf-recorder -o "$OUTPUT" \
      -f "$RECORD_DIR/recording-output-$TS.mp4"
    ;;
  stop)
    stop
    ;;
  *)
    exit 1
    ;;
esac
