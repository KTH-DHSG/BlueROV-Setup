# Revert to older version of snap (current one is broken) 
snap download snapd --revision=24724
sudo snap ack snapd_24724.assert
sudo snap install snapd_24724.snap
sudo snap refresh --hold snapd
# Install stuff
sudo apt install firefox -y
sudo apt install tmux -y

## Install ROS
locale  # check for UTF-8
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale  # verify settings
sudo apt install software-properties-common
sudo add-apt-repository universe -y
sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb
sudo apt update
sudo apt upgrade -y
sudo apt install ros-humble-desktop -y
sudo apt install ros-dev-tools -y
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Install realsense ros package
sudo apt install ros-$ROS_DISTRO-librealsense2* -y
sudo apt install ros-$ROS_DISTRO-realsense2-camera -y
sudo apt install ros-$ROS_DISTRO-realsense2-description -y


# Make a list of necessary spares
# Documentation incl all 3D parts etc
