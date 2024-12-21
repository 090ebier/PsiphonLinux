#! /bin/bash

# Variables
INSTALL_DIR="/etc/psiphon"
BINARY_URL="https://raw.githubusercontent.com/090ebier/psiphon-tunnel-core-binaries/master/linux/psiphon-tunnel-core-x86_64"
CONFIG_URL="https://raw.githubusercontent.com/090ebier/PsiphonLinux/main/psiphon.config"
STARTUP_SCRIPT_URL="https://raw.githubusercontent.com/090ebier/PsiphonLinux/main/psiphon"
SERVICE_FILE="/etc/systemd/system/psiphon.service"

# Create necessary directories
mkdir -p "$INSTALL_DIR"

# Download necessary scripts and files
echo "Starting downloads..."
wget -P "$INSTALL_DIR" "$BINARY_URL" --quiet
wget -P "$INSTALL_DIR" "$CONFIG_URL" --quiet
wget -P /usr/bin/ "$STARTUP_SCRIPT_URL" --quiet
echo "Downloads finished."

# Set permissions
chmod +x "$INSTALL_DIR/psiphon-tunnel-core-x86_64"
chmod +x /usr/bin/psiphon

# Create systemd service file
echo "Creating Psiphon service..."
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Psiphon Service
After=network.target

[Service]
ExecStart=/etc/psiphon/psiphon-tunnel-core-x86_64 -config /etc/psiphon/psiphon.config
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF


# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable and start the Psiphon service
systemctl enable psiphon
systemctl start psiphon

# Create a wrapper script for manual service management
echo "Creating wrapper script..."
cat <<EOF > /usr/bin/psiphon
#!/bin/bash
if [ "$1" == "start" ]; then
  sudo systemctl start psiphon
  echo "Psiphon service started."
elif [ "$1" == "stop" ]; then
  sudo systemctl stop psiphon
  echo "Psiphon service stopped."
elif [ "$1" == "status" ]; then
  sudo systemctl status psiphon
else
  echo "Usage: psiphon [start|stop|status]"
fi
EOF
chmod +x /usr/bin/psiphon

# Post-install checks
echo "Running post-install checks..."

if test -f "$INSTALL_DIR/psiphon-tunnel-core-x86_64"; then
    echo "Psiphon binary found."
else
    echo "ERROR: Psiphon binary not found!"
fi

if test -f "$INSTALL_DIR/psiphon.config"; then
    echo "Psiphon configuration found."
else
    echo "ERROR: Psiphon configuration not found!"
fi

if test -f /usr/bin/psiphon; then
    echo "Psiphon startup script found."
else
    echo "ERROR: Psiphon startup script not found!"
fi

if systemctl is-active --quiet psiphon; then
    echo "Psiphon service is running."
else
    echo "ERROR: Psiphon service is not running!"
fi

# Finish installation
echo "Installation completed. Psiphon service is now running in the background."
echo "You can manage the service with 'sudo psiphon [start|stop|status]'."
