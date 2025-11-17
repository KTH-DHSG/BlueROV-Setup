# BROV Jetson Internet Connection Setup

## CHANGELOG:

- 17.11.2025 document created; author(s): Cezary "Czarek" Banaszek [banaszek@kth.se](mailto:banaszek@kth.se)

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

You first need to find the following three names: `<internet-interface>`, `<USB-interface>` and `<jetson-interface>`. So traffic flows: Jetson (`<jetson-interface>`) → Switch → Laptop USB adapter/thether (`<USB-interface>`) → Laptop WiFi (`<laptop-interface>`) → Internet.

### Finding interface names:

You first need to find the following three names: `<internet-interface>`, `<USB-interface>` and `<jetson-interface>`

1. **Finding `<internet-interface>`:**
   
   run on laptop: 
   
   ```bash
   ip route | grep default
   ```
   
   Name of the internet interface should be there, e.g. `default via 10.0.0.1 dev wlp113s0f0 proto dhcp src 10.0.0.152 metric 600` hence `<internet-interface> = wlp113s0f0`

2. **Finding `<jetson-interface>`:**
   
   Next run on Jetson:
   
   ```bash
   ip -br addr show
   ```
   
   Name of the Jetson interface should be there, e.g. example output can be:
   
   ```bash
   lo               UNKNOWN        127.0.0.1/8 ::1/128 
   enP7p1s0         DOWN           
   enP8p1s0         UP             192.168.0.22/24 fe80::922:8c06:1177:eb4e/64 
   can0             DOWN           
   l4tbr0           DOWN           
   usb0             DOWN           
   usb1             DOWN           
   docker0          DOWN           172.17.0.1/16 
   ```
   
   hence `<jetson-interface> = enP8p1s0`

3. **Finding `<USB-interface>`:**
   
   Lastly, run on your laptop <u>with the Jetson plugged in via the tether/USB-interface</u>:
   
   ```bash
   ip addr show | grep 192.168.0
   ```
   
   Name of the USB interface should be there, e.g. example output can be:
   
   ```bash
   inet 192.168.0.2/24 brd 192.168.0.255 scope global noprefixroute enx00e033366ab1
   ```
   
   hence `<USB-interface> = enx00e033366ab1`

### Laptop side setup:

1. **Enable IP forwarding:**
   
   The laptop needs to be able to share network connection between devices.
   
   ```bash
   sudo sysctl -w net.ipv4.ip_forward=1
   ```

2. **Set up NAT**:
   Packets get their IP changed from Jetson's to the laptops public IP address allowing for connection. Without this, internet servers would try to reply directly to 192.168.0.XX (Jetson's private IP they can't reach), and the connection would fail. Notice that there the lack of `-i` argument. Basically ANY packet exiting the system via the laptop will have its IP reassigned this way via this specified interface.
   
   ```bash
   sudo iptables -t nat -A POSTROUTING -o <internet-interface> -j MASQUERADE
   ```

3. **Allow forwarding:**
   
   command 1: Allows traffic from the Jetson to go out to the internet through your laptop.
   
   command 2: Allows **reply traffic** from the internet back to the Jetson, but only for connections the Jetson initiated. This prevents unsolicited incoming connections to the Jetson while allowing responses to its outgoing requests.
   
   Together they create bidirectional traffic flow where the Jetson can initiate connections to the internet and receive replies, **but the internet cannot initiate new connections to the Jetson**.
   
   ```bash
   sudo iptables -A FORWARD -i <USB-interface> -o <internet-interface> -j ACCEPT
   sudo iptables -A FORWARD -i <internet-interface> -o <USB-interface> -m state --state RELATED,ESTABLISHED -j ACCEPT
   ```

4. **Save the iptables rules**
   Without this the rules will not hold after a reboot since they are not persistent.
   
   ```bash
   # install the package
   sudo apt install iptables-persistent
   # run it as a shell script since both parts of the command need
   # elevated sudo privilages
   sudo sh -c 'iptables-save > /etc/iptables/rules.v4'
   ```

### Jetson side setup:

1. **Check the device name**
   
   The list will show you all the devices that Jetson is connected to. Note the name of the XXX. It is most likely "Wired connection 2" for device XXX
   
   ```bash
   nmcli connection show
   ```

2. **Redefining the device name**
   
   **BE CAREFUL WITH THIS STEP**, if you are ssh'ed then you might lose connection after running the first command. Hopefully this does not stop jetson from running the command after the first one which redefines it under a different name. Otherwise you will need to connect to Jetson directly and run the second command from there.
   
   ```bash
   sudo nmcli connection delete "Wired connection 2"
   sudo nmcli connection add type ethernet con-name jetson-internet ifname <jetson-interface> \
     ipv4.method manual \
     ipv4.addresses <jetson-IP>/24 \
     ipv4.gateway <laptop-IP> \
     ipv4.dns "8.8.8.8 8.8.4.4" \
     autoconnect yes
   ```

3. **Test:**
   
   You should see data being received. If so you are now able to use the internet when ssh'ed to Jetson!
   
   ```bash
   ping 8.8.8.8
   ping google.com
   ```

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
