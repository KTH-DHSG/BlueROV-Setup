# Jetson Setup for Start to Finish
This tutorial encopases all that is needed to install Linux operating system with ConnectTech support packages
## Table of Contents
- [Before Installation](#before-installation)
- [Flashing Jetson with the Operating System](#flashing-jetson-with-the-operating-system)
- [Running the Setup Script After Installation](#running-the-setup-script-after-installation)

## Before Installation
Before we can begin the installation process, we need to install [Nvidia SDK Manager](https://developer.nvidia.com/sdk-manager). This step requires an active Nvidia account and unfortunately cannot be skipped.

1. Enable the recovery mode on the Jetson. To enable the recovery mode follow the steps described in the [manual](https://connecttech.com/ftp/pdf/CTIM-00095_Boson_Boson22_Manual.pdf). In short, connect the Jetson to its power supply, press and hold the recovery button (sw3) and press-release the reset button (sw2). When in the recovery mode the cooling fan should remain spinning.

2. Connect the Jetson using USB C to your computer.

3. Open Nvidia SDK Manager

4. Select Jetpack 6.2 rev. 2 (it can be hidden under all versions button)
    <p align="center">
    <img width="800" src="img/sdk1.png">
    </p>
5. Select the following modules to be installed:
    <p align="center">
    <img width="800" src="img/sdk2.png">
    </p>
6. After downloading the modules, on the prompt to flash the board, press skip.
7. Download a suitable [CTI support package for Jetpack 6.2](https://connecttech.com/resource-center/l4t-board-support-packages/) (DO NOT download RealTime OS), or use this [direct link to the package](https://connecttech.com/ftp/Drivers/CTI-L4T-ORIN-NX-NANO-36.4.3-V009.tgz).
8. Unzip the support package archive and make sure the top-most folder is called <strong>CTI-L4T</strong> and place it here: <code>/home/$USER/nvidia/nvidia_sdk/JetPack_6.2_Linux_JETSON_ORIN_NX_TARGETS/Linux_for_Tegra
</code> where <strong>$USER</strong> is your account username.

9. From terminal, go into <strong>CTI-L4T</strong> directory and execute \
    <code>sudo chmod +x install.sh</code> \
    <code>sudo ./install.sh</code>

10. 


## Flashing Jetson with the Operating System

## Running the Setup Script After Installation