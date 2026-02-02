# Clean up previous librealsense installations
sudo rm -f /usr/local/lib/librealsense*
sudo rm -rf /usr/local/include/librealsense2
sudo rm -rf /usr/local/lib/cmake/realsense2
sudo rm -f /usr/local/lib/pkgconfig/realsense2.pc
sudo rm -f /usr/local/bin/realsense-*
sudo rm -f /usr/local/bin/rs-*
sudo ldconfig

# Install dependencies
sudo apt update --allow-releaseinfo-change && sudo apt install -y  \
  build-essential \
  cmake \
  git \
  pkg-config \
  libusb-1.0-0-dev \
  libglfw3-dev \
  libgtk-3-dev \
  libssl-dev \
  libglu1-mesa-dev \
  libgl1-mesa-dev \
  v4l-utils \
  librealsense2-utils \
  librealsense2-dev \
  curl

cd ~
sudo rm -r librealsense || true
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
git checkout v2.55.1

mkdir build && cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_EXAMPLES=true \
  -DBUILD_GRAPHICAL_EXAMPLES=true \
  -DBUILD_WITH_CUDA=false \
  -DFORCE_RSUSB_BACKEND=true

make -j$(nproc)
sudo make install
sudo ldconfig

# sudo cp ~/librealsense/config/99-realsense-libusb.rules /etc/udev/rules.d/
# sudo udevadm control --reload-rules
# sudo udevadm trigger

# The camera requires the firmware with version 5.13.0.50. Download the firmware e.g. via wget ... and install it via:
# rs-fw-update -f D4XX_FW_Image-5.13.0.50.bin

# After installation finished you may test the installation by running:
# sudo rs-enumerate-devices
# You should see your device with all its sensors and details