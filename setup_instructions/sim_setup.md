## Installation process (in Linux):
>[!NOTE]
>We recommend using Ubuntu 22.04, ROS2 Humble and Gazebo Harmonic.

1. **Install DHSG PX4 fork and the DHSG custom gz models:**
    ```bash
    # 1) Clone DHSG PX4 fork
    git clone git@github.com:KTH-DHSG/PX4-Autopilot.git
    cd PX4-Autopilot
    
    # 2) Switch to DHSG branch with custom Gazebo models
    git checkout kth-model-changes
    
    # 3) Fetch all submodules at pinned versions
    git submodule sync --recursive
    git submodule update --init --recursive
    
    # 4) Install dependencies
    bash ./Tools/setup/ubuntu.sh
    
    # 5) Reboot recommended
    ```
    
2. **Build PX4 messages for ROS 2:**

   To communicate with the Pixhawk via ROS 2, you need its PX4 messages (available here: [PX4-msgs at GitHub](https://github.com/PX4/px4_msgs)) on your local machine:
    ```bash
    mkdir -p ~/px4_ws/src/
    cd ~/px4_ws/src/
    git clone git@github.com:PX4/px4_msgs.git
    cd ~/px4_ws
    colcon build
    source install/setup.bash
    ```
    
3. **Install QGroundControl:**
   
   QGroundControl is the ground control station used to interface with PX4 from a local machine. It is openly available here: [QGroundControl at GitHub](https://github.com/mavlink/qgroundcontrol).
    
    > ##### QGround Control Version
    >
    > We recommend using the latest daily build version available here: [QGroundControl Daily Builds](https://docs.qgroundcontrol.com/master/en/qgc-user-guide/releases/daily_builds.html#daily-builds).
    
    #### Setting up QGroundControl
    
    To build QGroundControl for Linux Ubuntu, you first need:
    ```bash
    sudo usermod -a -G dialout $USER
    sudo apt-get remove modemmanager -y
    sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
    sudo apt install libfuse2 -y
    sudo apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor-dev -y
    ```
    
    Logout and login again to enable the change to user permissions.
    
    After downloading QGroundControl, make it executable:
    ```bash
    chmod +x ./QGroundControl-x86_64.AppImage
    ```
    
    To launch it, simply run:
    ```bash
    ./QGroundControl-x86_64.AppImage
    ```
    
4. **Running the simulator:**
   
    The BlueROV2 with PX4 controller can be simulated using Gazebo. Gazebo should have been installed when setting up required packages for `PX4-Autopilot`. If not, installation instructions for Gazebo can be found [here](https://gazebosim.org/docs/harmonic/install_ubuntu/).
    
    With Gazebo installed, navigate to your local PX4 Autopilot directory and run the simulation:
    
    ```bash
    make px4_sitl_uuv gz_uuv_bluerov2_heavy
    ```
    
    Optionally, to run with ROS 2 namespace:
    
    ```bash
    PX4_UXRCE_DDS_NS=<namespace> make px4_sitl_uuv gz_uuv_bluerov2_heavy
    ```

    You can also run the simulator with the KTH Water Tank by using:

    ```bash
    PX4_GZ_WORLD=kth_marinarium make px4_sitl_uuv gz_uuv_bluerov2_heavy
    ```

    There is also a version with the docking station:

    ```bash
    PX4_GZ_WORLD=kth_marinarium_docking make px4_sitl_uuv gz_uuv_bluerov2_heavy
    ```
    
    #### Running Micro-XRCE-DDS-Agent Locally
    
    PX4 uses Micro-XRCE-DDS as middleware to allow its uORB messages to be published and subscribed to on a companion computer as though they were ROS 2 topics. Although the Micro-XRCE-DDS-Agent is preconfigured on the Jetson, we recommend installing it locally as well for simulation, testing, and development.
    
    Install Micro-XRCE-DDS-Agent from snap-store:
    
    ```bash
    sudo snap install micro-xrce-dds-agent --edge
    ```
    
    Once installed, connect to the PX4 by running:
    
    - **For Ethernet and Simulator connections:**
        ```bash
        micro-xrce-dds-agent udp4 -p 8888
        ```
    - **For Serial connections:**
        ```bash
        micro-xrce-dds-agent serial --dev <serial-port>
        ```
    
    #### Subscribe to topics
    
    Similarly to the hardware version, you should now see the SITL topics being published in ROS 2:
    ```bash
    ros2 topic list
    ros2 topic echo /fmu/out/vehicle_attitude
    ```
    Make sure you have sourced the PX4-msgs (step 2) in the same terminal you are doing the publishing and subscribing.
    
    The hardware is now being mimicked in software!

6. **Teleoperating the BlueROV2:**

   You can now plug in a joystick to control the simulator with QGC. If you don't have one the easiest way is to enable the virtual joystick in QGroundControl as explained [here](https://docs.qgroundcontrol.com/Stable_V4.3/en/qgc-user-guide/settings_view/virtual_joystick.html). I recommend to play with it to get to know it, and to use only Position mode, Stabilized mode and Acro mode (Manual mode should only be used if necessary, but otherwise avoid it).

7. **Getting to Offboard mode:**

   To send input commands through ROS2, you need to setup the vehicle in Offboard mode in QGroundControl. Typically, it does not show in the mode section since it is hidden by default so you need to click on the right arrow at the top of the Mode selection, then turn on the *Edit Displayed Flight Modes" slides and turn off the *Offboard* slider.

8. **Sending ROS2 control actuation:**

   Next, you need to have a heartbeat ROS2 node that constantly sends the offboard signal non-stop at more than 10Hz, this will allow you to arm the vehicle in QGC since by default Offboard will not let you. Note that you arm by clicking on the *Ready To Fly* text, then *Arm* and then moving the slider to the right.
    
    Now you can send inputs through the ``/fmu/in/vehicle_thrust_setpoint`` and ``/fmu/in/vehicle_torque_setpoint`` topics, the ``/fmu/in/vehicle_rates_setpoint`` topic or the ``/fmu/in/actuator_motors`` topic (depending on your heartbeat node type). You can find an example of my thrust_and_torque hearbeat node here: [https://kth-my.sharepoint.com/:u:/g/personal/vnfa_ug_kth_se/IQB1s1Xqxo_QSptLPT2AlvvkAd5DF3hMsSnaLL8aPBzlZ88?e=jHeFbE.](https://kth-my.sharepoint.com/:u:/g/personal/vnfa_ug_kth_se/IQB1s1Xqxo_QSptLPT2AlvvkAZ1-ba43ZigrbaFGL0r4nk8?e=un4wrJ). I recommend to always use thrust_and_torque.

9. If you want an example of a ROS2 controller working in the simulator you can check the **Stabilized Control** or **PID Position Control** from [here](https://github.com/KTH-DHSG/bluerov2_control). You may need to ask for permission to see the repo, if so email [Victor](vnfa@kth.se).
