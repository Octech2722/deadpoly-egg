#!/bin/bash
# Deadpoly Server Installation Script
# This script handles the installation of a Deadpoly dedicated server using Steam and Wine

# Update system and install dependencies
apt update
apt -y install curl lib32gcc-s1 lib32stdc++6 lib32tinfo6 lib32z1

# Create server directory structure
mkdir -p /mnt/server/steamcmd

# Download and extract SteamCMD
cd /tmp
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
cd /mnt/server/steamcmd

# Set up initial permissions
# SteamCMD requires this for installation
chown -R root:root /mnt
export HOME=/mnt/server

# Install Deadpoly Server through SteamCMD
./steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /mnt/server \
    +login anonymous \
    +app_update 2208380 validate \
    +quit

# Set up Steam SDK
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so /mnt/server/.steam/sdk64/steamclient.so

# Set up Wine environment
cd /mnt/server
mkdir -p .wine/drive_c/windows/syswow64
mkdir -p .wine/drive_c/windows/system32

# Set final permissions
chown -R container:container /mnt/server
