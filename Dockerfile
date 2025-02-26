FROM ubuntu:20.04

# Common maintainer and meta-data info
MAINTAINER Athanasios Tasoglou <dev@tasoglou.net>
LABEL Description="ROS 1 Noetic | Ubuntu 20.04 | mesa" Vendor="TurluCode"
LABEL com.turlucode.ros.version="noetic"

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

# Install common packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
sudo \
locales \
lsb-release \
git \
subversion \
nano \
vim \
xterm \
wget \
curl \
htop \
libssl-dev \
build-essential \
software-properties-common \
gdb \
valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Update locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Install cmake v3.29.3
RUN git clone https://github.com/Kitware/CMake.git && \
    cd CMake && git checkout tags/v3.29.3 && ./bootstrap --parallel=9 && make -j9 && make install && \
    cd .. && rm -rf CMake

# Install terminator
RUN apt-get update && apt-get install -y terminator adwaita-icon-theme-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.config/terminator/
COPY terminator_config /root/.config/terminator/config

# Install OhMyZSH
RUN apt-get update && apt-get install -y zsh && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
    chsh -s /usr/bin/zsh root && \
    git clone https://github.com/sindresorhus/pure /root/.oh-my-zsh/custom/pure && \
    ln -s /root/.oh-my-zsh/custom/pure/pure.zsh-theme /root/.oh-my-zsh/custom/ && \
    ln -s /root/.oh-my-zsh/custom/pure/async.zsh /root/.oh-my-zsh/custom/ && \
    sed -i -e 's/robbyrussell/refined/g' /root/.zshrc && \
    sed -i '/plugins=(/c\plugins=(git git-flow adb pyenv)' /root/.zshrc

# Latest MESA drivers. Currently for Ubuntu >=18.04 (https://launchpad.net/~kisak/+archive/ubuntu/turtle)
RUN add-apt-repository -y ppa:kisak/kisak-mesa && apt-get update && \
    apt-get install -y mesa-utils && apt-get --with-new-pkgs upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ROS 1 (noetic)
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
    libpcap-dev \
    libopenblas-dev \
    gstreamer1.0-tools libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev \
    ros-noetic-desktop-full python3-rosdep python3-rosinstall-generator python3-vcstool build-essential \
    ros-noetic-socketcan-bridge \
    ros-noetic-geodesy && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    rosdep init && rosdep update

RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "export ROSLAUNCH_SSH_UNKNOWN=1" >> /root/.bashrc && \
    echo "source /opt/ros/noetic/setup.zsh" >> /root/.zshrc && \
    echo "export ROSLAUNCH_SSH_UNKNOWN=1" >> /root/.zshrc

# Install tmux 3.4
RUN apt-get update && apt-get install -y \
    automake autoconf pkg-config libevent-dev libncurses5-dev bison && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/tmux/tmux.git && \
    cd tmux && git checkout tags/3.4 && sh autogen.sh && ./configure && make -j9 && make install && \
    cd .. && rm -rf tmux
RUN sed -i '/^plugins=/ s/)/ tmux)/' ~/.zshrc

# Install LLVM 18 (https://apt.llvm.org/). Supported is Ubuntu >= 18.04. Versions 9-18 (05/2024)
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 18 all && rm llvm.sh

# Install meld
RUN apt-get update && apt-get install -y meld adwaita-icon-theme-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Extra packages label
LABEL com.turlucode.extra_packages="cmake tmux llvm meld"

# Entry script
COPY entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]

# Run command
CMD ["terminator"]

