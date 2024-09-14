#!/bin/bash
#setting up

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/rhsalisu
sudo dscl . -create /Users/rhsalisu UserShell /bin/bash
sudo dscl . -create /Users/rhsalisu RealName "Rabiu Hadi Salisu"
sudo dscl . -create /Users/rhsalisu UniqueID 1001
sudo dscl . -create /Users/rhsalisu PrimaryGroupID 80
sudo dscl . -create /Users/rhsalisu NFSHomeDirectory /Users/rhsalisu
sudo dscl . -passwd /Users/rhsalisu root
sudo dscl . -passwd /Users/rhsalisu root
sudo createhomedir -c -u rhsalisu > /dev/null

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

#VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo root | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken 2jjqJ8mTlps4zo2wDNnREY5Xups_5BJT4C1zFSDQcyGQYqg1b
ngrok tcp 5900 &
ngrok tcp 22 &
