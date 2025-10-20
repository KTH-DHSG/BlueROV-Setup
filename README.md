# BlueROV-Setup

- [Using the BlueROV](setup_instructions/Usage.md): How to get started on a readily-prepared system
- [PX4 setup](setup_instructions/PX4_setup.md): How to set up software and communications
- [Jetson setup](setup_instructions/BlueROV_Jetson_setup.sh): Install script for a newly flashed Jetson
- [Hardware setup](setup_instructions/hardware_setup.md): Internal hardware setup

# Todos BlueROV mods

- [x] Figure out what's wrong with the actuators
- [ ] Correct buoyancy in assembled robot (do when the tank is unused)
- [x] Reassemble battery shelf to fit the BlueROVs (do with help)
- [ ] Assemble other robots
    - [x] Glub
    - [ ] Bubble
- [ ] Put ethernet switch and tether interface in bottom tube
    -> Later, it will be easy to install a water-tight plug s.t. the upper tube can easily be removed if desired
- [ ] install MicroDDS on all
    - [x] Glub
    - [ ] Splash
    - [ ] Bubble
- [ ] Test controlling multiple ROVs at once (can be dry test I guess?)

**Small tasks for in between**
- [ ] Prepare colors/names for the ROVs
- [ ] Prepare rails for the other BlueROVs
- [x] Jetson/Jetpack install on other BlueROVs

**Tasks for later**
- [ ] Add more intuitive controller:
    - Left joystick: forward/sideward
    - Right joystick: up-down/yaw
    - Implement in `/src/modules/uuv_att_control/uuv_att_control.cpp`
- [ ] Bring Jetsons directly into the lab network
- [ ] Maybe rethink the camera mount

# TODOs for documentation

- [ ] add wiring diagram
- [ ] add STLs

# To buy for BlueROV

- [ ] Leak sensor board (Tafarrel/Pedro seem to have ordere only one yet?) quite pricy with 35$ p.p. https://bluerobotics.com/store/sensors-cameras/leak-sensor/sos-leak-sensor/

