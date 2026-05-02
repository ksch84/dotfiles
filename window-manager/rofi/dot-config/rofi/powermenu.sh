#!/bin/bash

# Simple Rofi Power Menu

options="Lock\nLogout\nSuspend\nReboot\nShutdown"

selected=$(echo -e "$options" | rofi -dmenu -p "Power")

# Debug: write selection to a file
if [ -n "$selected" ]; then
    echo "Powermenu selected: $selected" >> /tmp/powermenu-debug.log
fi

case "$selected" in
    Lock)
        notify-send "Powermenu" "Locking session..." || echo "Lock: lock-session" >> /tmp/powermenu-debug.log
        loginctl lock-session 2>> /tmp/powermenu-debug.log
        ;;
    Logout)
        notify-send "Powermenu" "Logging out..." || echo "Logout: terminate-session" >> /tmp/powermenu-debug.log
        loginctl terminate-session ${XDG_SESSION_ID:-} 2>> /tmp/powermenu-debug.log
        ;;
    Suspend)
        notify-send "Powermenu" "Suspending..." || echo "Suspend" >> /tmp/powermenu-debug.log
        systemctl suspend 2>> /tmp/powermenu-debug.log
        ;;
    Reboot)
        notify-send "Powermenu" "Rebooting..." || echo "Reboot" >> /tmp/powermenu-debug.log
        systemctl reboot 2>> /tmp/powermenu-debug.log
        ;;
    Shutdown)
        notify-send "Powermenu" "Shutting down..." || echo "Shutdown" >> /tmp/powermenu-debug.log
        systemctl poweroff 2>> /tmp/powermenu-debug.log
        ;;
    "")
        ;;
    *)
        echo "Unknown: $selected" >> /tmp/powermenu-debug.log
        ;;
esac
