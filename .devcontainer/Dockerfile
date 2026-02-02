FROM althack/ros2:humble-dev 
RUN apt-get update && apt-get install -y \
    usbutils

# Install host setup script
COPY install_host.sh /usr/local/bin/install_host.sh

RUN bash /usr/local/bin/install_host.sh

# ROS workspace for realsense-ros wrapper
RUN mkdir -p /opt/ros_ws/src
WORKDIR /opt/ros_ws/src

# Clone the exact ROS wrapper version
# Clone the repo without checking out HEAD
RUN git clone https://github.com/IntelRealSense/realsense-ros.git /opt/ros_ws/src/realsense-ros && \
    cd /opt/ros_ws/src/realsense-ros && \
    git checkout tags/4.51.1

RUN rm -f /etc/apt/sources.list.d/yarn.list

# Build the workspace, but ignore librealsense2 packages as they are built locally in the correct version
WORKDIR /opt/ros_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
                  apt-get update --allow-releaseinfo-change && \
                  rosdep update && \
                  rosdep install --from-paths src --ignore-src -r -y --skip-keys='librealsense2 librealsense2-dev librealsense2-utils' && \
                  colcon build --symlink-install"
# Switch back to ros user
# USER ros

# Set up auto-source of workspace for ros user
ARG WORKSPACE
RUN echo "source /opt/ros_ws/install/setup.bash" >> ~/.bashrc
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> ~/.bashrc