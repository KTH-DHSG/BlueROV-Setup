Setup based on PX4 Autopilot
<details>

<summary>What's PX4?</summary>

- open software/hardware project serving as "brain" for all sorts of drones
- Advantages: 
    - Good software intergration: Easy integration of sensors etc., safety features, controller integration, ...
    - Open Source: Multiple manufacturers produce for PX4, if one product is discontinued, there is a plug-and-play replacement from another manufacturer. 
    - Good software integration with e.g. QGroundControl
- Do not confuse: 
    - PX4 Autopilot: The open-source system/project itself
    - PX6X: The specific hardware on which we are running PX4 Autopilot

</details>

# Interfaces:
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

# Flashing and Setting up PX4
Theoretically, the flashing should be easily doable through QGroundControl ([like this](https://docs.px4.io/main/en/config/firmware.html)). For current firmware version v1.16.0 this however leads to an incomplete install (BlueROV airframe not selectable), so this procedure works instead:

> [!TIP]  
> The target we use below is currently only available in the development release (v1.16.0.rc1), not in the latest stable release. Presumably this is why installing through QGroundControl does not work?

Follow the [spacelab setup](https://atmos.discower.io/pages/PX4/) for the first three steps ("PX4 Autopilot" section).

The firmware installation works similar, but we choose a _different target_ and _different default namespace_:

1. Connect the Pixhawk to your computer via serial. Make sure QGroundControl is closed.
2. Navigate to the cloned PX4-Autopilot directory.
3. Upload the firmware using:

```
PX4_UXRCE_DDS_NS=itrl_<robot name> make px4_fmu-v6x_uuv upload
```

# Communication Setup
Communication mainly follows standard networking approaches -> Knowledge of setting up IP networks is advantageous
- Fathom-X is simply a transparent ethernet bridge (without own IP adress or so), whole network is a standard ethernet network
- PX6X needs to be configured for communication over Ethernet. General instructions are [here](https://docs.px4.io/main/en/advanced_config/ethernet_setup), our setup follows:

Goal: Have all three BlueROVs connected to the same computer

Current setup: Follow original setup closely

USB-Switch connecting to all Fathom-X interfaces. Each USB-cable should be detected as individual USB-ethernet interface in system network settings.

## User-side setup
Probably easies to connect and set up one BlueROV at a time. Each connection gets its own network setting with own IP adress in the 192.168.0.X range, e.g.
- 192.168.0.1
- 192.168.0.2
- 192.168.0.3

1. Go to Settings > Network > Add
2. Under Identity > Name, choose
    - a profile name
    - MAC address: Choose from dropdown
3. Under IPv4, choose
    - IPv4 Method: Manual
    - Address: 192.168.0.X (see above)
    - Netmask: 255.255.255.0
    - Gateway: 0.0.0.0
4. Apply settings

## BlueROV-side setup

### PX4

The network setup on robot side can be changed through QGroundControl. The current configuration is

| BlueROV | PX4 IP address    | Jetson IP address |
|---------|-------------------|-------------------|
| splash  | 192.168.0.10      | 192.168.0.20      |
| bubble  | 192.168.0.11      | 192.168.0.21      |
| glub    | 192.168.0.12      | 192.168.0.22      |

To set these, go to "Analyze Tools > MavLink Console"

```
# Overwrite the file (note the single > on first line)
echo DEVICE=eth0 > /fs/microsd/net.cfg
echo BOOTPROTO=fallback >> /fs/microsd/net.cfg
echo IPADDR=192.168.0.X >> /fs/microsd/net.cfg    # Replace X with the respective adress above
echo NETMASK=255.255.255.0 >> /fs/microsd/net.cfg
echo ROUTER=192.168.0.231 >> /fs/microsd/net.cfg  # Or whatever the router/DNS server adress is
echo DNS=192.168.0.231 >> /fs/microsd/net.cfg

# Then reboot to apply
reboot
```

### Jetson 

Under Settings > Network > Realtek Ethernet set a static IP with the addresses stated above. The process is the same one as the user-side setup without the extra steps.

> [IMPORTANT!]
> This setup does _not_ allow the Jetson to access the internet. To achieve this, two methods are possible (plus the alternative setup described below).
> 1. Enable IP forwarding and set up NAT (Network Address Translation) on your desktop computer 
> 2. Take of the shell on the front (camera side), connect an ethernet cable to the second ethernet port of the Jetson
> Personally, I think that the alternative setup has a lot of advantages and simplifies working with the robots a lot.

<details>

<summary>__Alternative setup directly over network__</summary>

A better setup could be that the BlueROVs are directly connected to the lab network. Then, any computer in the network could access them (i.e. also over Wifi). This could be rather easily achieved as follows:

The blue Fathom-X box contains the same tether interface that is also in the BlueROV. The interface has an ethernet port, that is (in the current configuration) routed through an adapter board to the USB port of the Fathom-X. This ethernet port could instead be directly connected to a switch on the lab network (i.e. without the USB board in the Fathom-X). Any computer on the same network could then find the robots, and also the three-fold setup of the UBS-ethernet on user side would not be needed any more. IP addresses would centrally be assigned by DHCP reservation on network side through MAC address.

```
Setup now:
                         Fathom-X interface                                                                  
                       ┌────────────────────────────────────────────┐                                        
   ┌─────────┐         │                     Standard               │       ┌───────────────┐                
   │         │ Tether  │ ┌──────────────────┐Ethernet┌────────────┐ │ USB   │               │                
   │ BlueROV ├─────────┼─┤ Ethernet interfac├────────┤Ethernet to ├─┼───────┤ Your computer │                
   │         │         │ └──────────────────┘        │USB-Ethernet│ │       │               │                
   └─────────┘         │                             └────────────┘ │       └───────────────┘                
                       │                                            │                                        
                       └────────────────────────────────────────────┘                                        
                                                                                                             
Alternative setup:
                         Fathom-X interface                                                                  
                       ┌────────────────────────────────────────────┐                                        
   ┌─────────┐         │                     Standard               │       ┌───────────────┐                
   │         │ Tether  │ ┌──────────────────┐Ethernet               │       │               │                
   │ BlueROV ├─────────│─┤ Ethernet interfac├───────┐               │       │ Your computer │                
   │         │         │ └──────────────────┘       │               │       │               │                
   └─────────┘         │                            │               │       └─────┬─────────┘                
                       │                            │               │             │                          
                       └────────────────────────────┼───────────────┘             │Internet connection       
                                                    │                             │over Lab network          
                                                    │                             │- ethernet, wifi,...      
                                                    │                             │                          
                                                    │                       ┌─────┴────┐                     
                                                    └───────────────────────│ Ethernet │                     
                                                     Other BlueROV ─────────│ Switch   │                     
                                                     Other BlueROV ─────────│          │                     
                                                                            └──────────┘                     
```

(If you're wondering why the interface exists at all: The tether is a 2-wire ethernet cable that is better for long distances - on both ends, this is then converted through the adapter to standard ethernet. For some reason, BlueRobotics decided that it is better to have this additionally converted on user-side to USB-ethernet.)

> [IMPORTANT!]
> Before setting up this variant: Make sure that there are enough Ethernet ports available in the Marinarium (seems like their ethernet switch has not too many ports). Maybe necessary to buy an additional switch.
</details>


