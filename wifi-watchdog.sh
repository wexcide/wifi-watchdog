#!/bin/bash

# Settings
WIFI_IFACE="wlp2s0"                    # Change to your Wi-Fi interface name (ip a to list and identify)
PING_TARGET="8.8.8.8"                  # IP to test connectivity
LOGFILE="/var/log/wifi-watchdog.log"   # Log location

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

# Check connectivity
if ping -q -c 3 -W 2 "$PING_TARGET" > /dev/null; then
    log "Internet is up."
else
    log "Internet is down. Attempting to restart Wi-Fi..."

    # Restart Wi-Fi using NetworkManager
    nmcli radio wifi off
    sleep 2
    nmcli radio wifi on
    sleep 5  # Give time to reconnect

    # Re-check connectivity
    if ping -q -c 3 -W 2 "$PING_TARGET" > /dev/null; then
        log "Wi-Fi successfully restored."
    else
        log "Wi-Fi restart failed to restore internet."
    fi
fi
