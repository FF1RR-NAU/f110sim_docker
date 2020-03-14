FROM nxtruong/rosmelodicvnc:latest
MAINTAINER Truong Nghiem <truong.nghiem@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Uncomment to install some utility programs
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends --allow-unauthenticated \
# 	   libreoffice \
# 	   vlc flvstreamer ffmpeg \
#     && apt-get autoclean \
#     && apt-get autoremove \
#     && rm -rf /var/lib/apt/lists/*

# Set up VLC under root
# RUN cp /usr/bin/vlc /usr/bin/vlc_backup
# RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc


## Install ROS packages for the simulator

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install dependencies for the F1/10 Tutorials
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
    ros-melodic-ros-control \
    # ros-melodic-gazebo-ros-control \
    ros-melodic-ros-controllers \
    ros-melodic-navigation \
    ros-melodic-ackermann-msgs \
    ros-melodic-serial \
    ros-melodic-joy \
	ros-melodic-map-server \
    libeigen3-dev \
	&& apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Update rosdep
RUN rosdep update

# symbolic link for Eigen
RUN /bin/bash -c 'cp -r /usr/include/eigen3/Eigen /usr/include'

# Clone and build the Racecar simulator
RUN mkdir -p /home/catkin_ws/src/f110_simulator
RUN git clone https://github.com/FF1RR-NAU/f110_simulator.git /home/catkin_ws/src/f110_simulator
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/catkin_ws; catkin_make'

EXPOSE 80
WORKDIR /home/
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
