#!/bin/bash

# Mute toggle button for polybar
# On normal exec: display current mute state
# On click: toggle mute

# If this is a click event
if [ "$1" = "--click" ]; then
    MUTE=$(pactl list sinks | grep -oP 'Mute: \Kyes|no' | head -1)
    if [ "$MUTE" = "yes" ]; then
        pactl set-sink-mute @DEFAULT_SINK@ no
    else
        pactl set-sink-mute @DEFAULT_SINK@ yes
    fi
    exit 0
fi

# Display current mute state
MUTE=$(pactl list sinks | grep -oP 'Mute: \Kyes|no' | head -1)
if [ "$MUTE" = "yes" ]; then
    echo "%{T2}%{F#99aa99}󰝟%{F-}%{T-}"
else
    echo "%{T2}%{F#99aa99}󰙪%{F-}%{T-}"
fi
