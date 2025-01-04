#!/bin/bash
# Deadpoly Server Installation Script
# This script handles the installation of a Deadpoly dedicated server using Steam and Wine

# Enable error handling
set -e

# Output some information
echo "Starting Deadpoly Server installation..."

# Update system and install dependencies
echo "Installing dependencies..."
apt update
apt -y install curl lib32gcc-s1 lib32stdc++6 lib32tinfo6 lib32z1

# Create server directory structure
echo "Creating directory structure..."
mkdir -p /mnt/server/steamcmd

# Download and extract SteamCMD
echo "Downloading SteamCMD..."
cd /tmp
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
cd /mnt/server/steamcmd

# Set up initial permissions
echo "Setting up initial permissions..."
chown -R root:root /mnt
export HOME=/mnt/server

# Install Deadpoly Server through SteamCMD
echo "Installing Deadpoly Server (App ID: 2208380)..."
./steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /mnt/server \
    +login anonymous \
    +app_update 2208380 validate \
    +quit || exit 1

# Set up Steam SDK
echo "Setting up Steam SDK..."
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so /mnt/server/.steam/sdk64/steamclient.so

# Set up Wine environment
echo "Configuring Wine environment..."
cd /mnt/server
mkdir -p .wine/drive_c/windows/syswow64
mkdir -p .wine/drive_c/windows/system32

# Set final permissions
echo "Setting final permissions..."
chown -R container:container /mnt/server

echo "Installation complete!"
