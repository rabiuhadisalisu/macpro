#!/bin/bash
# Setting up

# Disable Spotlight indexing (requires sudo privileges)
echo "Disabling Spotlight indexing..."
sudo mdutil -i off -a

# Create a new user account
USERNAME="rhsalisu"
REALNAME="Rabiu Hadi Salisu"
PASSWORD="StrongP@ssw0rd123"
echo "Creating new user account: $USERNAME"
sudo dscl . -create /Users/$USERNAME
sudo dscl . -create /Users/$USERNAME UserShell /bin/bash
sudo dscl . -create /Users/$USERNAME RealName "$REALNAME"
sudo dscl . -create /Users/$USERNAME UniqueID 1001
sudo dscl . -create /Users/$USERNAME PrimaryGroupID 80
sudo dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
sudo pwpolicy -clearaccountpolicies
echo "Setting password for $USERNAME..."
echo "$PASSWORD" | sudo dscl . -passwd /Users/$USERNAME -
sudo createhomedir -c -u $USERNAME > /dev/null

# Enable VNC
echo "Enabling VNC access for all users..."
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes

# Set VNC password (hashed)
echo "Setting VNC password..."
VNC_PASSWORD="$PASSWORD"
echo -n "$VNC_PASSWORD" | perl -we '
    BEGIN {
        @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"
    };
    $_ = <>;
    chomp;
    s/^(.{8}).*/$1/;
    @p = unpack "C*", $_;
    foreach (@k) {
        printf "%02X", $_ ^ (shift @p || 0)
    };
    print "\n"
' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

# Restart and activate VNC
echo "Restarting and activating VNC server..."
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

# Install ngrok using Homebrew
echo "Installing ngrok..."
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Please install it and run this script again."
    exit 1
fi
brew install --cask ngrok

# Configure ngrok and start it
NGROK_AUTH_TOKEN="2jjqJ8mTlps4zo2wDNnREY5Xups_5BJT4C1zFSDQcyGQYqg1b"
echo "Configuring ngrok..."
ngrok config add-authtoken $NGROK_AUTH_TOKEN
echo "Starting ngrok for VNC (port 5900)..."
ngrok tcp 5900 &

# Optional: Start ngrok for SSH (port 22)
# echo "Starting ngrok for SSH (port 22)..."
# ngrok tcp 22 &
