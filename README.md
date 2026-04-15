# BlueROV-Setup

- [Using the BlueROV](setup_instructions/Usage.md): How to get started on a readily-prepared system
- [PX4 setup](setup_instructions/PX4_setup.md): How to set up software and communications
- [Jetson OS and CUDA setup](setup_instructions/Jetson_setup.md): Flashing Linux with support packages and installing CUDA
- [Jetson software setup](setup_instructions/scripts/BlueROV_Jetson_setup.sh): Install script for a newly flashed Jetson
- ~~[Internet on Jetson](setup_instructions/Jetson_internet.md): Getting internet access to Jetson via tether~~ To be fixed
- [Hardware setup](setup_instructions/hardware_setup.md): Internal hardware setup
- [SITL Simulation setup](setup_instructions/sim_setup.md): PX4 gz STIL simulation setup
- [Wiring diagram](setup_instructions/brov-wiring-diagram-inkscape.svg): for more details on our specific hardware adaptations
- [ROS2 Software Stack](https://github.com/KTH-DHSG/BlueROV-ROS-Modules): The repository conating the software stack for the BROV2s

# TODOs BlueROV mods

- [x] Figure out what's wrong with the actuators
* [x] Correct buoyancy in assembled robot (do when the tank is unused)
- [x] Reassemble battery shelf to fit the BlueROVs (do with help)
- [x] Assemble other robots
  - [x] Glub
  - [ ] <del>Bubble</del>
- [ ] Put ethernet switch and tether interface in bottom tube
    -> Later, it will be easy to install a water-tight plug s.t. the upper tube can easily be removed if desired
- [x] install MicroDDS on all
  - [x] Glub
  - [x] Splash
  - [ ] <del>Bubble</del>
- [ ] Test controlling multiple ROVs at once (can be dry test I guess?)
- [ ] Add startup scripts in Jetson and PX4 to
  - [ ] auto-start the MVALink-ROS2 Bridge (see Usage.md#Start PX4/ROS communication)
  - [ ] auto-start camera node

**Small tasks for in between**

- [x] Prepare colors/names for the ROVs
- [x] Prepare rails for the other BlueROVs
- [x] Jetson/Jetpack install on other BlueROVs

**Tasks for later**

- [x] Add more intuitive controller:
  - Left joystick: forward/sideward
  - Right joystick: up-down/yaw
  - Implement in `/src/modules/uuv_att_control/uuv_att_control.cpp`
- [x] Bring Jetsons directly into the lab network
* [x] Maybe rethink the camera mount

# TODOs for stereo vision

- [x] Train YOLO underwater to recognize other BROV2s.
- [x] Calibrate stereo-depth underwater.
- [ ] Check USB 3.0 connection for stereo-cam to Jetson, maybe through USB-C to USB-C
- [ ] Train YOLO underwater to recognize divers and pose estimation.

# TODOs for SITL simulation

- [ ] Create a multi-agent water tank simulation with multiple brov2s using https://github.com/DISCOWER/discower_launch/tree/main/discower_launch/launch

# TODOs for documentation

- [x] add wiring diagram
- [x] add STLs

# To buy for BlueROV

- [ ] Leak sensor board (Tafarrel/Pedro seem to have ordered only one yet?) quite pricy with $35 p.p. https://bluerobotics.com/store/sensors-cameras/leak-sensor/sos-leak-sensor/
- [ ] Thick line/cable for pulling stuff underwater (Cezary).
- [x] Materials for docking station.
- [x] Extra tether connectors and HDMI dummys for Jetsons.

# To assemble

- [ ] Docking station.
- [x] Passive gripper: boat hook pole mechanism; and test payload with comically large handle.
- [ ] Create a third tether cable to FXTI box with the extra connectors.