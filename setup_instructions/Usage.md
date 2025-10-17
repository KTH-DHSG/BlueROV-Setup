# Quick tutorial

This is a short tutorial on how to use the BlueROVs with QGroundControl.

## Operate in manual mode

1. Setup
If not already happened, 
- Install QGroundControl from the official resources
- Make sure to follow the user-side setup in [PX4_setup.md](PX4_setup.md). 

2. Connect the Fathom-X Interface with a USB port on your computer on the one side and with the BlueROV tether on the other.

**insert image**

3. Open QGroundControl. After a short while, the robot should be connected and it should look like this:

![Connected](ready_to_fly.png)

> [!NOTE]
> It might also look like this:
> 
> ![Connected](ready_to_fly_2.png)
> 
> This can happen as no remote control is configured - we use the BlueROV only via QGroundControl and Joystick. You can ignore this therefore. To verify if this is the issue, go to "Q">"Vehicle Configuration". Everything should be green besides of "Radio". 

4. Plug in the joystick, arm the vehicle and have fun! If you are connected, but something is not working, go to "Q">"Vehicle Configuration" and resolve the issues.

## Connect to Jetson

1. See steps 1 and 2 above. 
2. Verify that you have a connection to the robot by opening QGroundControl or 
```
ping 192.168.0.<your robots IP>
```
3. Connect to the Jetson over SSH via
```
ssh discower@<jetson_IP>
```
for user and PW 'discower'.
4. Optional: Start all ROS services, e.g. start the Intel RealSense node.
```
ros2 run realsense2_camera realsense2_camera_node
```

> [!NOTE]
> The Jetson has by default no access to the internet. Refer to [PX4_setup.md](PX4_setup.md) for more information regarding package installation etc.

