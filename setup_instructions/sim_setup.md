### Installation process (in Linux):
1. Install DHSG PX4 fork and the DHSG custom gz models:
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
2. Build PX4 messages for ROS 2. To communicate with the Pixhawk via ROS 2, you need its PX4 messages (available here: PX4-msgs at GitHub) on your local machine:
    ```bash
    mkdir -p ~/px4_ws/src/
    cd ~/px4_ws/src/
    git clone git@github.com:PX4/px4_msgs.git
    cd ~/px4_ws
    colcon build
    source install/setup.bash
    ```
3. Install QGroundControl by doing all the steps in "Vehicle Configuration and QGroundControl" to before "PX4 Vehicle Setup" from here: https://atmos.discower.io/pages/PX4/#px4-autopilot.
4. Follow the steps from here: https://atmos.discower.io/pages/Simulation/ with one big difference, instead of px4_sitl_spacecraft gz_atmos you should use px4_sitl_uuv gz_uuv_bluerov2_heavy. Make sure to also do the steps for the Micro-XRCE-DDS-Agent since it's needed for the ROS2 connection.
5. Controlling the uuv is a bit convoluted. The easiest is that you enable the virtual joystick in QGroundControl: https://docs.qgroundcontrol.com/Stable_V4.3/en/qgc-user-guide/settings_view/virtual_joystick.html and play with it. I recommend using Position and Stabilized mode, and only Manual if necessary.
6. To send input commands through ROS2, you need to setup the vehicle in Offboard mode in QGroundControl, typically it does not show in the mode section since it is hidden so you need to click on Configure on the side and click on it to make it shown. Then you need to have a heartbeat ROS2 node that constantly sends the offboard signal non-stop, this will allow you to arm the vehicle in QGC (by Clicking on the name of the Mode, then Arm and then moving the slider) and you can then send inputs through the thrust and torque setpoint topics or the motors topic (depending on your heartbeat node). You can find an example of my thrust_and_torque hearbeat node here: [https://kth-my.sharepoint.com/:u:/g/personal/vnfa_ug_kth_se/IQB1s1Xqxo_QSptLPT2AlvvkAd5DF3hMsSnaLL8aPBzlZ88?e=jHeFbE.](https://kth-my.sharepoint.com/:u:/g/personal/vnfa_ug_kth_se/IQB1s1Xqxo_QSptLPT2AlvvkAZ1-ba43ZigrbaFGL0r4nk8?e=un4wrJ). [SOMEONE NEEDS TO TEST SENDING COMMANDS THROUGH ROS2 WORKS].
