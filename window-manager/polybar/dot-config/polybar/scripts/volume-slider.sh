#!/bin/bash

# Volume slider for polybar
# Shows the volume of the default output as a bar of blocks.
# Prints once at start and again every time PulseAudio reports a change, so
# nothing runs while the volume stays the same (polybar module: tail = true).

SLIDER_WIDTH=6

render() {
    # Volume (0-100+) and mute state of the DEFAULT output.
    # (`pactl list sinks` would read the first output, which is not
    # necessarily the one you are listening to.)
    local volume mute filled empty bar i
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d '%')
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'Mute: \K(yes|no)')

    # Number of filled blocks; never more than the slider is wide
    # (volume can go above 100%)
    filled=$((volume * SLIDER_WIDTH / 100))
    [ "$filled" -gt "$SLIDER_WIDTH" ] && filled=$SLIDER_WIDTH
    empty=$((SLIDER_WIDTH - filled))

    # Build the bar: filled full blocks followed by empty light blocks
    bar=""
    for ((i = 0; i < filled; i++)); do bar+="▓"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done

    # Show slider grayed out when muted
    if [ "$mute" = "yes" ]; then
        echo "%{T2}%{F#666}${bar}%{F-}%{T-}"
    else
        echo "%{T2}%{F#99aa99}${bar}%{F-}%{T-}"
    fi
}

render

# `pactl subscribe` prints one line per event, e.g. "Event 'change' on sink #1".
# Redraw on output ("sink") and default-output ("server") changes only.
exec {events}< <(pactl subscribe)
subscribe_pid=$!
# stop pactl when polybar stops this script, so no process is left behind
trap 'kill "$subscribe_pid" 2>/dev/null' EXIT
trap 'exit' TERM INT

while read -r -u "$events" line; do
    case "$line" in
        *" on sink "* | *" on server "*) render ;;
    esac
done
