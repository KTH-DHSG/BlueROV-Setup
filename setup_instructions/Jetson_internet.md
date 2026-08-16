# BROV Jetson Internet Connection Setup

## Description

The goal of this tutorial is to allow the Jetson computer access the internet via the BROVs ethernet thether connection.

## Prerequisites

You need to first setup the ethernet connection between BROV and your laptop. If you are able to ssh to Jetson then you're good in that regard.

## Procedure

### Laptop-side setup:
First, we need to find the network devices that interface the Internet \<Internet-facing\> and the BROV2 \<LAN-facing\>.

To find \<Internet-facing\> we run:
```bash
ip route | grep default
```
Which can produce ouput similar to this:
```bash
default via 10.0.0.1 dev enxc0470e89b222 proto dhcp metric 103 
default via 10.0.0.1 dev wlp113s0f0 proto dhcp metric 600 
```
The \<Internet-facing\> can be then either <code>enxc0470e89b222</code> which is the ethernet adapter connected to the lab, and <code>wlp113s0f0</code> which is the WiFi adapter.

To find \<LAN-facing\> we run (in a similar fashion):
```bash
ip route | grep 192.168
```
Which can produce the output:
```bash
192.168.0.0/24 dev enx00e03336699a proto kernel scope link src 192.168.0.3 metric 102
```
Now, the last IP address in the line above is the IP we assigned to the laptop using the GUI when first setting up the network over the tether.

```bash
# configure the iptables
sudo iptables -t nat -A POSTROUTING -o <Internet-facing>  -j MASQUERADE
sudo iptables -A FORWARD -i <Internet-facing> -o <LAN-facing> -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i <LAN-facing> -o <Internet-facing>  -j ACCEPT
```
Then save the config to make it pesistent:
```bash
# donwload persistent iptables and save the current settings
sudo apt install iptables-persistent
sudo netfilter-persistent save

# make the forwarding permament
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Jetson-side setup:
All of the required changes to the settings should have been already installed automatically by this stage of the setup process.

**Check**:
```bash
sudo cat /etc/netplan/01-netcfg.yaml
```
If nothing is displayed, it means that the automatic setup was unsuccessful and the following needs to be done on the Jetson.

**Option 1**: Use the script <code>jetson_internet_setup.sh</code> located in the <code>scripts/</code> directory.

**Option 2**: Follow the tutorial below:

Find Jetson LAN-facing device:
```bash
ip route | grep default
```
Which produces very similar output to the previous cases. Chose the device that has the LAN connection. We will call it \<Jetson-LAN-facing\>

```bash
# download netplan
sudo apt install netplan.io

# create a new netplan rule
sudo tee /etc/netplan/01-netcfg.yaml << 'EOF'
network:
  version: 2
  ethernets:
    enP8p1s0:
      dhcp4: false
      addresses:
        - 192.168.0.22/24
      routes:
        - to: default
          via: 192.168.0.3
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF

# fix the permissions and apply
sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan apply
```
**IMPORTANT!** Change the Jetson's network device name from <code>enP8p1s0</code> to \<Jetson-LAN-facing\>.
This netplan setup assumes the laptop has configured its IP to be <code>192.168.0.3</code>, so adjust this line if the IP is different. Similarily, the IP <code>192.168.0.22/24</code> is the IP we want to assign to the BROV2, change this line if you want a different one.

Now check if the Jetson has access to the Internet:
```bash
# ping google to see if it resolves
ping -c 3 google.com
# ping the laptop to see if it resolves
ping -c 3 192.168.0.22

```