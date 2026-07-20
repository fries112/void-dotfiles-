#!/bin/bash
# VOID Screen Recorder - GPU-accelerated via gpu-screen-recorder
# Super+Shift+R to start/stop recording

RECORD_DIR="$HOME/Videos/Recordings"
mkdir -p "$RECORD_DIR"

PID_FILE="/tmp/void-recorder.pid"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    kill "$(cat "$PID_FILE")"
    rm -f "$PID_FILE"
    notify-send "VOID Recorder" "Recording stopped"
    exit 0
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT="$RECORD_DIR/void_${TIMESTAMP}.mp4"

gpu-screen-recorder -w screen -f 60 -o "$OUTPUT" -q high &
echo $! > "$PID_FILE"
notify-send "VOID Recorder" "Recording started"
