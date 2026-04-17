# BROV Jetson Internet Connection Setup
## TO-DO:

- add NetPlan so the ethernet connection set up does not need to be repeated via GUI each time on the laptop side, check if it is still an issue though after this setup

- test how this tutorial works when setup for more than one brov on the same laptop (look for conflicts)

- move the commands into two shell scripts (with input parameters for interface names and laptop IP) for the jetson and the laptop to make it easier and faster to setup

## Description

The goal of this tutorial is to allow the Jetson computer access the internet via the BROVs ethernet thether connection.

WARNING: this set up is designed for a single BROV. It might not work when trying to follow the instruction for another BROV using the same laptop/PC. It might overwrite some settings. This is something that still needs to be tested and expanded on.

## Prerequisites

1. You need to first setup the ethernet connection between BROV and your laptop. If you are able to ssh to Jetson then you're good in that regard.

2. The IP you set for your computer/laptop does matter here! The recommended convention is for the laptop computer to be: `192.168.0.X` whereas Jetson's IP is `192.168.0.(X+20)` e.g. `192.168.0.2` and `192.168.0.22`. In this tutorial laptop's IP will be referred to as `<laptop-IP>` whereas Jetson's IP will be `<jetson-IP>`.

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
Now, the last IP address in the line above is the IP we assigned to the laptop using the GUI when first setting up the net

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

Check:
```bash
sudo cat /etc/netplan/01-netcfg.yaml
```
If nothing is displayed, it means that the automatic setup was unsuccessful and the following needs to be done on the Jetson.

```bash
# download netplan
sudo apt install netplan.io

# create a new netlan rule
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
IMPORTANT! This netplan setup assumes the laptop has configured its IP to be <code>192.168.0.3</code>, so adjust this line if the IP is different.


## Issues and Tips

## References

- [IP Forwarding Linux: How to Enable/Disable net.ipv4.ip_forward](https://linuxconfig.org/how-to-turn-on-off-ip-forwarding-in-linux)

- [NAT with Linux | Marcus Folkesson Blog](https://www.marcusfolkesson.se/blog/nat-with-linux/)

- [Network Address Translation (NAT) - GeeksforGeeks](https://www.geeksforgeeks.org/computer-networks/network-address-translation-nat/)

- https://articulatedrobotics.xyz/tutorials/ready-for-ros/networking

- https://sudamtm.medium.com/iptables-a-comprehensive-guide-276b8604eff1

- [iptables(8) - Linux man page](https://linux.die.net/man/8/iptables)

- https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html#STATEMATCH

- [Make Iptables Rules Persistent on Linux](https://linuxconfig.org/how-to-make-iptables-rules-persistent-after-reboot-on-linux)
