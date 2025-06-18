FROM --platform=linux/amd64 debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    clang \
    bison \
    flex \
    libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    graphviz \
    xdot \
    pkg-config \
    python3 \
    python3-pip \
    libboost-all-dev \
    libeigen3-dev \
    zlib1g-dev \
    qt5-qmake \
    qtbase5-dev \
    wget \
    curl \
    libftdi-dev \
    libusb-1.0-0-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install CMake 3.27 (or newer)
WORKDIR /tmp
RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.27.9/cmake-3.27.9-linux-x86_64.sh && \
    chmod +x cmake-3.27.9-linux-x86_64.sh && \
    ./cmake-3.27.9-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.27.9-linux-x86_64.sh

WORKDIR /opt

# Install yosys
RUN git clone --recursive https://github.com/YosysHQ/yosys.git
WORKDIR /opt/yosys
RUN make -j$(nproc) && make install

# Install IceStorm
RUN git clone https://github.com/YosysHQ/icestorm.git && \
    cd icestorm && \
    make -j$(nproc) && \
    make install

# Install nextpnr
WORKDIR /opt
RUN git clone https://github.com/YosysHQ/nextpnr.git
WORKDIR /opt/nextpnr/build
RUN cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j$(nproc) && \
    make install

WORKDIR /project