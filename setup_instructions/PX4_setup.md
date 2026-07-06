# PX4 Setup

---

## Table of Contents

- [What's PX4?](<PX4_setup#What's PX4?>)
- [Interfaces](PX4_setup#Interfaces:)
- [Flashing and Setting up PX4](<PX4_setup#Flashing and Setting up PX4>)
- [Communication Setup](<PX4_setup#Communication Setup>)
  - [User-side setup](<PX4_setup#User-side setup>)
  - [BlueROV-side setup](<PX4_setup#BlueROV-side setup>)
    - [Jetson](PX4_setup#Jetson)
    - [PX4](PX4_setup#PX4)
    - [PX4 Setup](<PX4_setup#PX4 Setup>)
- [Common Issues](<PX4_setup#Common Issues>)

---

## What's PX4?

- open software/hardware project serving as "brain" for all sorts of drones
- Advantages:
  - Good software intergration: Easy integration of sensors etc., safety features, controller integration, ...
  - Open Source: Multiple manufacturers produce for PX4, if one product is discontinued, there is a plug-and-play replacement from another manufacturer.
  - Good software integration with e.g. QGroundControl
- Do not confuse:
  - PX4 Autopilot: The open-source system/project itself
  - PX6X: The specific hardware on which we are running PX4 Autopilot

</details>

## Interfaces:

- Physical Interfaces
  - Tether:
    - connect Fathom-X tether interface via USB to your computer
    - Establishes an ethernet connection to the whole BlueROV (i.e. the PX6X, but also e.g. the Jetson)
    - setup instructions: see below (todo: insert link)
  - USB-C:
    - connect directly from your computer to PX6X (requires removal of tube)
    - Fallback if PX6X is not available over Ethernet
    - For now needed to update the firmware of the PX6X
- Software interfaces:
  - QGroundControl
    - Allows to set most settings in an easy-to-use graphical interface
    - Console interface under "Analyze Tools > MavLink Console" for advanced use cases
  - ROS2 interface: MavLink to ROS2 bridge (todo: insert link)

---

## Flashing and Setting up PX4

Theoretically, the flashing should be easily doable through QGroundControl ([PX4 Doc > Config > Firmware](https://docs.px4.io/main/en/config/firmware.html)). For current firmware version v1.16.0 this however leads to an incomplete install (BlueROV airframe not selectable), so this procedure works instead:

Follow the [spacelab setup](https://atmos.discower.io/pages/PX4/) for the first three steps ("PX4 Autopilot" section).

The firmware installation works similar, but we choose a _different target_ and _different default namespace_:

1. Connect the Pixhawk to your computer via serial. Make sure QGroundControl is closed.
2. Navigate to the cloned PX4-Autopilot directory and ensure that the build environment is clean.

```bash
make clean
```

3. Export the name of the robot to setup the DDS.

```bash
export PX4_UXRCE_DDS_NS=<robot_name>
```

4. Upload the firmware using:

```bash
make px4_fmu-v6x_uuv upload
```

> [!Note]
> The target we use below is currently only available in the development release (v1.16.0.rc1), not in the latest stable release.

---

## Communication Setup

Communication mainly follows standard networking approaches -> Knowledge of setting up IP networks is advantageous

- Fathom-X is simply a transparent ethernet bridge (without own IP adress or so), whole network is a standard ethernet network
- PX6X needs to be configured for communication over Ethernet. General instructions are under [PX4 docs > Advanced Config > Ethernet Setup](https://docs.px4.io/main/en/advanced_config/ethernet_setup), our setup follows:

Goal: Have all three BlueROVs connected to the same computer

Current setup: Follow original setup closely

USB-Switch connecting to all Fathom-X interfaces. Each USB-cable should be detected as individual USB-ethernet interface in system network settings.

### User-side setup

Probably the easiest is to connect and set up one BlueROV at a time. Each Fathom-X Interface box (FXTI) connection gets its own network setting with own IP adress and subnet.

| BlueROV | Laptop IP | Subnet Mask (Netmask) | Gateway | Status |
| --- | --- | --- | --- | --- |
| Splash | 192.168.0.1 | 255.255.255.0 | 0.0.0.0 | Done |
| Bubble | 192.168.1.2 | 255.255.255.0 | 0.0.0.0 | Done |
| Glub | 192.168.2.3 | 255.255.255.0 | 0.0.0.0 | To be done |



1. Go to Settings > Network > Add
2. Under Identity > Name, choose
   - a profile name (we suggest the name of the BROV)

3. Under IPv4, choose
   - IPv4 Method: Manual
   - Fill the corresponding fields from the table above

4. Apply settings

> [!NOTE]  
> The first time you connect to QGC with the BlueROV2 and the Fathom, it can take a long time for the PX4 to be detected.

### BlueROV-side setup

#### PX4

The network setup on robot side can be changed through QGroundControl. The current configuration is

| BlueROV | UXRCE_DDS_KEY | MAV_SYS_ID| Fathom (Laptop) IP | PX4 IP | Subnet Mask | Status |
|---|---|---|---|---|---|---|
| Splash | 1 | 1 | 192.168.0.1 | 192.168.0.10 | 255.255.255.0 | Done |
| Bubble | 2 | 2 | 192.168.1.2 | 192.168.1.11 | 255.255.255.0 | Done |
| Glub | 3 | 3 | 192.168.2.3 | 192.168.2.12 | 255.255.255.0 | To be done |

>[!Important]
> Each BROV should have a different UXRCE_DDS_KEY (default -1) **AND** MAV_SYS_ID (default 1). This can be changed in the parameters tab in QGroundControl.

To ensure that we can run multiple BROVs at the same time, we must ensure that they run on separate subnets. They should already be set correctly and **we recommend to not touch this**, but in case you need to you can change them by doing the following: go to "Analyze Tools > MavLink Console". Then type params (or any other keyword) so that you can see the console shows "nsh>" instead of just ">". Then input:

```
# Splash
echo DEVICE=eth0 > /fs/microsd/net.cfg
echo BOOTPROTO=fallback >> /fs/microsd/net.cfg
echo IPADDR=192.168.0.10 >> /fs/microsd/net.cfg
echo NETMASK=255.255.255.0 >> /fs/microsd/net.cfg
echo ROUTER=192.168.0.1 >> /fs/microsd/net.cfg
echo DNS=192.168.0.1 >> /fs/microsd/net.cfg
reboot
```

```
# Bubble
echo DEVICE=eth0 > /fs/microsd/net.cfg
echo BOOTPROTO=fallback >> /fs/microsd/net.cfg
echo IPADDR=192.168.1.11 >> /fs/microsd/net.cfg
echo NETMASK=255.255.255.0 >> /fs/microsd/net.cfg
echo ROUTER=192.168.1.2 >> /fs/microsd/net.cfg
echo DNS=192.168.1.2 >> /fs/microsd/net.cfg
reboot
```

```
# Glub
echo DEVICE=eth0 > /fs/microsd/net.cfg
echo BOOTPROTO=fallback >> /fs/microsd/net.cfg
echo IPADDR=192.168.2.12 >> /fs/microsd/net.cfg
echo NETMASK=255.255.255.0 >> /fs/microsd/net.cfg
echo ROUTER=192.168.2.3 >> /fs/microsd/net.cfg
echo DNS=192.168.2.3 >> /fs/microsd/net.cfg
reboot
```

Rebooting through the MavLink Console sometimes does not work. You can also go to Vehicle Configuration > Parameters tab and then click Tools > Reboot Vehicle.

Now you should be able to run the Micro-XRCE-DDS-Agent and use ROS2 topics as described in the simulator section: [sim_setup.md](sim_setup.md). 

>[!Note] Note that if you have changed the Fathom (laptop) address you need to change the UXRCE_DDS_AG_IP parameter in the Parameters tab of QGC to the signed int32 equivalent of your Fathom IP address.
<p align="center">
<image src=img/multipleBROVsQGroundROS.png>
</p>

#### Jetson

Under Settings > Network > Realtek Ethernet set a static IP with the addresses stated above. The process is the same one as the user-side setup without the extra steps.

> [!IMPORTANT]
> This setup does _not_ allow the Jetson to access the internet. To achieve this, two methods are possible (plus the alternative setup described below).
>
> 1. Enable IP forwarding and set up NAT (Network Address Translation) on your desktop computer
> 2. Take of the shell on the front (camera side), connect an ethernet cable to the second ethernet port of the Jetson
>    Personally, I think that the alternative setup has a lot of advantages and simplifies working with the robots a lot.
---

## Common Issues
PX4 Issues:

1. Micro XRCE DDS doesn't connect to the companion laptop.
   When the Micro XRCE DDS agent doesn't detect the DDS client running on PX4, it most likely means that the IP set for the companion laptop is not the same set in the DDS config. To check the IP targeted by the client on PX4, do the following: Open **QGround**/**Analyze Tools**/**MAVlink Console** and type in the terminal

   ```bash
    xrce_dds_client status
   ```

   This should output the current targeted IP of the DDS client running on PX4. Make sure the companion computer that is supposed to receive the ROS2 messages has the same IP configured in the network settings.

   The IP used by the DDS client on PX4 can be changed if need be. To do so go into **QGround**/**Parameters** and search for **XRCE_DDS_IP_AG** and change that parameter to the IP you want the client to target.

   > [!Caution]
   > The parameter used in QGround is in `int32` format so the IP has to be converted to a binary representation first and then saved in `int32`. This can be done using C/C++ type `int32_t`.

2. Gazebo simulation doesn't have the BROV2 models.
   The PX4 repository used for the PX4 flashing is the official one, hence it doesn't have the required files for Gazebo simulation. To get the PX4 fork that has the Gazebo files, follow the simulation instructions here [https://github.com/KTH-DHSG/BlueROV-Setup/blob/main/setup_instructions/sim_setup.md](https://github.com/KTH-DHSG/BlueROV-Setup/blob/main/setup_instructions/sim_setup.md)
