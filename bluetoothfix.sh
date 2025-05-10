#!/bin/bash
# On MacBooks, Bluetooth audio can be unreliable due to the design of the internal antenna.
# After several attempts and configurations, the most stable solution appears to be disabling
# the internal Bluetooth adapter and using an external USB Bluetooth dongle instead.
#
# This script:
# - Enables the external Bluetooth adapter
# - Disables the internal Bluetooth adapter
# - Creates a systemd user service to automate the process on every boot/login
#
# Requirements:
# 1. The 'bluez-utils' package must be installed (provides 'bluetoothctl')
# 2. Set the correct permissions so it can be executed but not modified by normal users:
#      sudo chmod 755 /usr/local/bin/bluetoothfix.sh
#      (Note: 'chmod +x' is redundant if you already used 755)
# 3. Enable the systemd user service with:
#      systemctl --user daemon-reexec
#      systemctl --user enable bluetoothfix.service
#      systemctl --user start bluetoothfix.service

# Check if bluetoothctl is available
if ! command -v bluetoothctl >/dev/null 2>&1; then
    echo "Error: bluetoothctl not found. Please install the 'bluez-utils' package."
    exit 1
fi

# Define MAC addresses
EXTERNAL_BT_MAC="5C:F3:70:9F:C4:10"
INTERNAL_BT_MAC="98:01:A7:A7:C1:6C"

# Create systemd user directory if it doesn't exist
mkdir -p ~/.config/systemd/user

# Define the systemd unit file path
SERVICE_FILE=~/.config/systemd/user/bluetoothfix.service

# If the service file doesn't exist, create it and enable it
if [ ! -f "$SERVICE_FILE" ]; then
    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Enable external Bluetooth adapter on MacBook
After=bluetooth.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/bluetoothfix.sh

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable bluetoothfix.service
fi

# Execute the Bluetooth adapter switch
bluetoothctl << EOF
select $EXTERNAL_BT_MAC
power on
agent on
default-agent
select $INTERNAL_BT_MAC
power off
EOF
