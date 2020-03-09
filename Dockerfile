FROM nxtruong/roskineticvnc:latest
MAINTAINER Truong Nghiem <truong.nghiem@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

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

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

## Install ROS packages for the simulator

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install dependencies for the F1/10 Tutorials
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated\
    python-rosinstall-generator \
    ros-kinetic-ros-control \
    # ros-kinetic-gazebo-ros-control \
    ros-kinetic-ros-controllers \
    ros-kinetic-navigation qt4-default \
    ros-kinetic-ackermann-msgs \
    ros-kinetic-serial \
    ros-kinetic-joy \
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
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /home/catkin_ws; catkin_make'

EXPOSE 80
WORKDIR /home/
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
