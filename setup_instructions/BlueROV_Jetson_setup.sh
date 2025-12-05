#!/bin/bash

sudo apt update && sudo apt install -y locales
sudo locale-gen en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

sudo apt install software-properties-common
sudo add-apt-repository universe -y
sudo apt update && sudo apt install curl -y

echo "Installing ROS2 Humble..."
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')

curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"

sudo dpkg -i /tmp/ros2-apt-source.deb
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    ros-humble-desktop \
    ros-dev-tools
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

echo "Installing Nvidia Wheel and PyTorch..."
CUSPARSELT_URL="https://developer.download.nvidia.com/compute/cusparselt/redist/libcusparse_lt/linux-aarch64"
CUSPARSELT_VERSION="0.7.1.0"
CUSPARSELT_NAME="libcusparse_lt-linux-aarch64-${CUSPARSELT_VERSION}-archive"
mkdir -p tmp_cusparselt && cd tmp_cusparselt
curl --retry 3 -OLs "${CUSPARSELT_URL}/${CUSPARSELT_NAME}.tar.xz"
tar xf "${CUSPARSELT_NAME}.tar.xz"
cp -a "${CUSPARSELT_NAME}/include/"* /usr/local/cuda/include/
cp -a "${CUSPARSELT_NAME}/lib/"* /usr/local/cuda/lib64/
cd ..
rm -rf tmp_cusparselt
ldconfig
python3 -m pip install -U --no-cache https://developer.download.nvidia.com/compute/redist/jp/v61/pytorch/torch-2.5.0a0+872d972e41.nv24.08.17622132-cp310-cp310-linux_aarch64.whl
sudo apt-get install -y \
    libjpeg-dev \
    zlib1g-dev \
    libpython3-dev \
    libopenblas-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev
echo "Building TorchVision..."
git clone --branch release/0.20 https://github.com/pytorch/vision torchvision
cd torchvision
BUILD_VERSION=0.20.0
python3 setup.py install --user
cd ..
rm -rf torchvision

echo "Installing Python YOLO Modules..."
python3 -m pip install -U ultralytics supervision

echo "Installing ROS2 Humble Packages..."
sudo apt install -y \
    ros-$ROS_DISTRO-librealsense2* \
    ros-$ROS_DISTRO-realsense2-* \
    ros-$ROS_DISTRO-vision-msgs

echo "Installing microRTPS-ROS2 bridge..."
# Install microRTPS-ROS2 bridge https://docs.px4.io/main/en/ros2/user_guide#installation-setup

sudo apt install python3-setuptools -y
sudo apt install python3-pip -y
sudo pip3 install -U 'empy<4' pyros-genmsg
git clone -b v2.4.3 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/


