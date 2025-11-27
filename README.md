# BlueROV-Setup

- [Using the BlueROV](setup_instructions/Usage.md): How to get started on a readily-prepared system
- [PX4 setup](setup_instructions/PX4_setup.md): How to set up software and communications
- [Jetson OS and CUDA setup](setup_instructions/Jetson_setup.md): Flashing Linux with support packages and installing CUDA
- [Jetson software setup](setup_instructions/BlueROV_Jetson_setup.sh): Install script for a newly flashed Jetson
- [Internet on Jetson](setup_instructions/Jetson_internet.md): Getting internet access to Jetson via tether
- [Hardware setup](setup_instructions/hardware_setup.md): Internal hardware setup
- [Wiring diagram](setup_instructions/brov-wiring-diagram-inkscape.svg): for more details on our specific hardware adaptations

# Todos BlueROV mods

- [x] Figure out what's wrong with the actuators
* [x] Correct buoyancy in assembled robot (do when the tank is unused)
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
- [ ] Add startup scripts in Jetson and PX4 to
  - [ ] auto-start the MVALink-ROS2 Bridge (see Usage.md#Start PX4/ROS communication)
  - [ ] auto-start camera node

**Small tasks for in between**

- [ ] Prepare colors/names for the ROVs
- [ ] Prepare rails for the other BlueROVs
- [x] Jetson/Jetpack install on other BlueROVs

**Tasks for later**

- [ ] Add more intuitive controller:
  - Left joystick: forward/sideward
  - Right joystick: up-down/yaw
  - Implement in `/src/modules/uuv_att_control/uuv_att_control.cpp`
- [x] Bring Jetsons directly into the lab network
* [x] Maybe rethink the camera mount

# TODOs for documentation

- [x] add wiring diagram
- [x] add STLs

# To buy for BlueROV

- [ ] Leak sensor board (Tafarrel/Pedro seem to have ordere only one yet?) quite pricy with 35$ p.p. https://bluerobotics.com/store/sensors-cameras/leak-sensor/sos-leak-sensor/
