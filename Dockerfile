# Other destros may not be supported with all of the packages listed below
ARG ROS_DISTRO=humble 

# This is an auto generated Dockerfile for ros:ros-base
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:${ROS_DISTRO}-ros-core

# # nvidia-container-runtime
# ENV NVIDIA_VISIBLE_DEVICES \
#     ${NVIDIA_VISIBLE_DEVICES:-all}
# ENV NVIDIA_DRIVER_CAPABILITIES \
#     ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENV MAIN_WS /docker_ros
ENV ROS_WS ${MAIN_WS}/ros2_ws
ENV DRIVER_WS ${MAIN_WS}/drivers_ros2_ws

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    sudo apt install libasio-dev \
    && rm -rf /var/lib/apt/lists/* 
    

# install nano and pip
RUN apt-get update && apt-get install -y nano \
    python3-pip \
    && pip3 install --upgrade pip

# Install Segmentation Libraries
RUN python3 -m pip install numpy matplotlib opencv-python 
# RUN python3 -m pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113 
# RUN python3 -m pip install 'git+https://github.com/facebookresearch/detectron2.git'
# RUN git clone https://github.com/bytedance/kmax-deeplab.git && cd kmax-deeplab && python3 -m pip install -r requirements.txt

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-desktop \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install ros-${ROS_DISTRO}-gtsam cmake vim tmux -y && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc 


RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

RUN apt-get update && \
    sudo apt install ros-${ROS_DISTRO}-pcl-msgs \
    ros-${ROS_DISTRO}-vision-opencv \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-camera-calibration-parsers \
    ros-$ROS_DISTRO-message-filters \
    ros-${ROS_DISTRO}-xacro -y \
    
    # && sudo apt install ros-${ROS_DISTRO}-perception-pcl




WORKDIR ${ROS_WS}

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "source ${DRIVER_WS}/install/setup.bash" >> ~/.bashrc
