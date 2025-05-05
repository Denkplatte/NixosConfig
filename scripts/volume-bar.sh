#!/bin/bash

# Get current volume (assumes PulseAudio or PipeWire with pactl)
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# Build bar: 10 chars total
FILLED=$(( VOLUME / 10 ))
EMPTY=$(( 10 - FILLED ))
BAR=$(printf "[%0.s#" $(seq 1 $FILLED))
BAR+=$(printf "%0.s-" $(seq 1 $EMPTY))
BAR+="]"

echo "{\"text\": \"$BAR\", \"tooltip\": \"Volume: $VOLUME%\"}"
