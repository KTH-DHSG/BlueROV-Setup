# Hardware Setup

This article is concerned with the internal setup of the robots. It is directed at everyone who wants to do own modifications on the hardware. For usage instructions, see [here](Usage.md).

The basic hardware setup follows the instructions by [Blue Robotics](https://bluerobotics.com/learn/bluerov2-assembly)[^1]. In addition, some modifications have been made:

- Replaced flight controller from BlueRobotics/Raspberry Pi-based with PX4 Autopilot (Holybro PX6X)
- Added top tube
- Added Jetson Orin NX
- Added Intel Realsense
- Added network switch
- Software setup, not the scope of this page

The hardware instructions can still be useful for (e.g.)

- assembly of the battery tub and central tube
- how to make the robot waterproof (and test that it actually is)
- ESC setup
- how individual parts s.a. Fathom-X tether work
- ...

It is recommended to take a look at them!

[^1]: Make sure to select the "Heavy configuration" when looking at the instructions.

## Vacuum testing

If new tubes / cables between tubes / ... are installed, a prelimiary vaccum test should be preformed. In general, the instructions from BlueRobotics [here](https://bluerobotics.com/learn/bluerov2-assembly/#preliminary-vacuum-test) can be followed. Make sure to

- Start with the equipment test. If the vacuum pump + connections themselves are not tight, try with zip ties.
- Test all tubes at the same time, otherwise it will not work. Combine as many T-formed hose connectors as you need to connect to all tubes.
- Disassemble the equipment after use: Over time, the hoses will otherwise take the shape of the connectors, so the pressure at the connection pieces decreases and they will start to leak air.
