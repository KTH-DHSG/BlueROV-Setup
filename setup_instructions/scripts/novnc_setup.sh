#!/bin/bash

echo "------------------------------------"
echo "**Installing NOVNC Server**"
echo "------------------------------------"

sudo apt update && \
sudo apt install -y \
    dbus-x11 \
    sudo \
    bash \
    net-tools \
    novnc \
    x11vnc \
    xvfb \
    supervisor \
    xfce4 \
    gnome-shell \
    ubuntu-gnome-desktop \
    gnome-session \
    gdm3 \
    tasksel \
    ssh \
    terminator \
    git \
    nano \
    curl \
    wget \
    zip \
    unzip \
    falkon \
    mesa-utils