#!/bin/bash

# Mute toggle button for polybar
# With --click: toggle mute and exit
# Without: show the current mute state now and again on every change
# (polybar module: tail = true)

# Is the default output muted? Prints "yes" or "no".
is_muted() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'Mute: \K(yes|no)'
}

# If this is a click event
if [ "$1" = "--click" ]; then
    if [ "$(is_muted)" = "yes" ]; then
        pactl set-sink-mute @DEFAULT_SINK@ no
    else
        pactl set-sink-mute @DEFAULT_SINK@ yes
    fi
    exit 0
fi

render() {
    if [ "$(is_muted)" = "yes" ]; then
        echo "%{T2}%{F#99aa99}󰝟%{F-}%{T-}"
    else
        echo "%{T2}%{F#99aa99}󰙪%{F-}%{T-}"
    fi
}

render

# Redraw whenever PulseAudio reports a change on an output ("sink") or the
# default output ("server"), see volume-slider.sh
exec {events}< <(pactl subscribe)
subscribe_pid=$!
trap 'kill "$subscribe_pid" 2>/dev/null' EXIT
trap 'exit' TERM INT

while read -r -u "$events" line; do
    case "$line" in
        *" on sink "* | *" on server "*) render ;;
    esac
done
