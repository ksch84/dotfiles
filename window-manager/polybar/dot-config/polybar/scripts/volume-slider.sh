#!/bin/bash

# Volume slider for polybar
# Shows visual slider

# Get current volume (0-100)
VOLUME=$(pactl list sinks | grep -o '[0-9]*%' | head -1 | tr -d '%')
MUTE=$(pactl list sinks | grep -oP 'Mute: \Kyes|no' | head -1)

# Slider configuration
SLIDER_WIDTH=6
FILLED=$((VOLUME * SLIDER_WIDTH / 100))
EMPTY=$((SLIDER_WIDTH - FILLED))

FILLED_BAR=$(printf '▓%.0s' $(seq 1 $((FILLED + 1))))
EMPTY_BAR=$(printf '░%.0s' $(seq 1 $((EMPTY + 1))))

# Show slider grayed out when muted
if [ "$MUTE" = "yes" ]; then
    echo "%{T2}%{F#666}${FILLED_BAR}${EMPTY_BAR}%{F-}%{T-}"
else
    echo "%{T2}%{F#99aa99}${FILLED_BAR}${EMPTY_BAR}%{F-}%{T-}"
fi
