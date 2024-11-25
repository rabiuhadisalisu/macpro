#!/bin/bash

# Variables
VNC_DOWNLOAD_URL="https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-7.13.0-MacOSX-universal.pkg?lai_vid=aqKaBLMqAh6qE&lai_sr=5-9&lai_sl=l"
VNC_PKG_NAME="VNC-Server-7.13.0-MacOSX-universal.pkg"
TEMP_DIR="/tmp/vnc_server_install"
VNC_INSTALL_DIR="/Library/vnc"
VNC_SERVICE_BINARY="$VNC_INSTALL_DIR/vncserver-root"
VNC_RELOAD_CMD="/Library/vnc/vncserver -reload"
VNC_START_CMD="/Library/vnc/vncserver -service"
VNC_STOP_CMD="/Library/vnc/vncserver -service -stop"

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

# Verify installation
if [ ! -f "$VNC_SERVICE_BINARY" ]; then
    echo "Error: VNC Server binary not found at $VNC_SERVICE_BINARY."
    exit 1
fi

# Start VNC Server
echo "Starting VNC Server as a service..."
sudo "$VNC_START_CMD"
if [ $? -ne 0 ]; then
    echo "Error: Failed to start VNC Server."
    exit 1
fi

# Reload parameters and licenses
echo "Reloading VNC Server parameters and licenses..."
sudo "$VNC_RELOAD_CMD"
if [ $? -ne 0 ]; then
    echo "Error: Failed to reload VNC Server parameters."
    exit 1
fi

# Cleanup
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "VNC Server installed, started, and configured successfully!"
