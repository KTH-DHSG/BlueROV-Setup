#!/bin/bash
# Ask for Jetson IP upfront
echo "------------------------------------"
echo "** Network Configuration"
echo "------------------------------------"
read -p "Enter Jetson static IP (e.g. 192.168.0.22): " JETSON_IP
read -p "Enter gateway IP (laptop's LAN IP, e.g. 192.168.0.3): " GATEWAY_IP

echo "Jetson IP: $JETSON_IP"
echo "Gateway:   $GATEWAY_IP"
read -p "Confirm? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Aborted."
    exit 1
fi

echo "Setting up static IP and internet access..."
sudo apt install netplan.io -y
sudo tee /etc/netplan/01-netcfg.yaml << EOF
network:
  version: 2
  ethernets:
    enP8p1s0:
      dhcp4: false
      addresses:
        - ${JETSON_IP}/24
      routes:
        - to: default
          via: ${GATEWAY_IP}
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF
sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan apply

echo -e "Installation complete!"
echo "Jetson configured with IP: $JETSON_IP, Gateway: $GATEWAY_IP"