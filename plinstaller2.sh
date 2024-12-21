#! /bin/bash

# Variables
INSTALL_DIR="/etc/psiphon"  # پوشه نصب برای فایل‌ها
BINARY_URL="https://raw.githubusercontent.com/090ebier/PsiphonLinux/refs/heads/main/psiphon-tunnel-core-x86_64"  # لینک دانلود فایل باینری
CONFIG_URL="https://raw.githubusercontent.com/090ebier/PsiphonLinux/main/psiphon.config"  # لینک دانلود فایل تنظیمات
STARTUP_SCRIPT_URL="https://raw.githubusercontent.com/090ebier/PsiphonLinux/main/psiphon"  # لینک دانلود اسکریپت راه‌اندازی
SERVICE_FILE="/etc/systemd/system/psiphon.service"  # فایل سرویس systemd

# Create necessary directories
mkdir -p "$INSTALL_DIR"  # ایجاد دایرکتوری برای نصب فایل‌ها

# Download necessary scripts and files
echo "Starting downloads..."
wget -P "$INSTALL_DIR" "$BINARY_URL" --quiet  # دانلود فایل باینری
wget -P "$INSTALL_DIR" "$CONFIG_URL" --quiet  # دانلود فایل تنظیمات
wget -P /usr/bin/ "$STARTUP_SCRIPT_URL" --quiet  # دانلود اسکریپت راه‌اندازی به /usr/bin
echo "Downloads finished."

# Set permissions
chmod +x "$INSTALL_DIR/psiphon-tunnel-core-x86_64"  # دادن دسترسی اجرایی به باینری
chmod +x /usr/bin/psiphon  # دادن دسترسی اجرایی به اسکریپت راه‌اندازی

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
echo "You can manage the service with 'sudo systemctl [start|stop|status] psiphon'."
