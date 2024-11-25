#!/bin/bash

# Variables
VNC_DOWNLOAD_URL="https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-7.13.0-MacOSX-universal.pkg?lai_vid=aqKaBLMqAh6qE&lai_sr=5-9&lai_sl=l"
VNC_PKG_NAME="VNC-Server-7.13.0-MacOSX-universal.pkg"
TEMP_DIR="/tmp/vnc_server_install"

# Create a temporary directory for downloading the VNC package
echo "Creating temporary directory: $TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Download the VNC package
echo "Downloading VNC Server package..."
curl -L -o "$TEMP_DIR/$VNC_PKG_NAME" "$VNC_DOWNLOAD_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the VNC package."
    exit 1
fi

# Install the package
echo "Installing VNC Server..."
sudo installer -pkg "$TEMP_DIR/$VNC_PKG_NAME" -target /
if [ $? -ne 0 ]; then
    echo "Error: Failed to install VNC Server."
    exit 1
fi

# Start the VNC Server
echo "Starting VNC Server..."
sudo /Library/Application\ Support/RealVNC/VNC\ Server/vncinitconfig -configure
sudo /Library/Application\ Support/RealVNC/VNC\ Server/RFBProxy --start
if [ $? -ne 0 ]; then
    echo "Error: Failed to start VNC Server."
    exit 1
fi

# Enable VNC Server to start at boot
echo "Enabling VNC Server to start at boot..."
sudo /bin/launchctl load -w /Library/LaunchDaemons/com.realvnc.vncserver.plist

# Cleanup
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "VNC Server installed and started successfully!"
