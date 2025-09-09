#!/bin/bash
# TODO: Attempt to identify wireless card automatically.

set -e

# Ask for the Wi-Fi interface name
read -rp "Enter your Wi-Fi interface name (e.g., wlan0, wlp3s0): " INTERFACE

# Confirm interface exists
if ! nmcli device status | grep -q "$INTERFACE"; then
    echo "Error: Interface '$INTERFACE' not found in NetworkManager."
    exit 1
fi

echo "Setting up WiFi watchdog for interface: $INTERFACE"

# Script path
SCRIPT_PATH="/usr/local/bin/wifi-watchdog.sh"
LOGFILE="/var/log/wifi-watchdog.log"

# Create the watchdog script
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash

INTERFACE="$INTERFACE"
PING_TARGET="8.8.8.8"
LOGFILE="$LOGFILE"

log() {
    echo "\$(date '+%Y-%m-%d %H:%M:%S') \$1" >> "\$LOGFILE"
}

if nmcli networking connectivity check | grep -q "full"; then
    log "Internet is up."
else
    log "Internet is down. Restarting Wi-Fi on \$INTERFACE..."
    nmcli device disconnect "\$INTERFACE"
    sleep 2
    nmcli device connect "\$INTERFACE"
    log "Wi-Fi interface \$INTERFACE reconnected via nmcli."
fi
EOF

# Make script executable
chmod +x "$SCRIPT_PATH"
echo "Created $SCRIPT_PATH"

# Create systemd service
SERVICE_FILE="/etc/systemd/system/wifi-watchdog.service"
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=WiFi Watchdog
After=network.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
EOF

echo "Created $SERVICE_FILE"

# Create systemd timer
TIMER_FILE="/etc/systemd/system/wifi-watchdog.timer"
cat <<EOF > "$TIMER_FILE"
[Unit]
Description=Run WiFi Watchdog every 2 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=2min
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo "Created $TIMER_FILE"

# Reload systemd and enable the timer
systemctl daemon-reload
systemctl enable --now wifi-watchdog.timer

echo "WiFi Watchdog service and timer enabled and running."
echo
echo "Setup complete!"
echo
echo "To check status:"
echo "  sudo systemctl status wifi-watchdog.timer"
echo "  sudo journalctl -u wifi-watchdog.service --no-pager"
echo "  cat /var/log/wifi-watchdog.log"
