FROM nvcr.io/nvidia/isaac/ros:aarch64-ros2_humble_adc428c7077de4984a00b63c55903b0a

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Essentials
RUN apt-get update --allow-releaseinfo-change && apt-get install -y --no-install-recommends \
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
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-tqdm \
    wget \
    udev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install librealsense 2.55.1 from source
RUN git clone -b v2.55.1 https://github.com/IntelRealSense/librealsense.git /opt/librealsense && \
    cd /opt/librealsense && mkdir build && cd build && \
    cmake ../ -DBUILD_EXAMPLES=true -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && make install

# Copy udev rules (for host, container will need --privileged / -v /dev)
RUN cp /opt/librealsense/config/99-realsense-libusb.rules /etc/udev/rules.d/

# ROS workspace for realsense-ros wrapper
RUN mkdir -p /opt/ros_ws/src
WORKDIR /opt/ros_ws/src

# Clone the exact ROS wrapper version
# Clone the repo without checking out HEAD
RUN git clone https://github.com/IntelRealSense/realsense-ros.git /opt/ros_ws/src/realsense-ros && \
    cd /opt/ros_ws/src/realsense-ros && \
    git checkout tags/4.51.1

RUN rm -f /etc/apt/sources.list.d/yarn.list

# Build workspace
WORKDIR /opt/ros_ws
RUN . /opt/ros/humble/setup.bash && \ 
    apt-get update --allow-releaseinfo-change && rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --symlink-install

# # Install the Isaac ROS vSLAM packages
RUN apt-get install -y \
    ros-humble-isaac-ros-visual-slam

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /opt/ros_ws/install/setup.bash" >> ~/.bashrc

# Set up auto-source of workspace for ros user
ARG WORKSPACE
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> ~/.bashrc