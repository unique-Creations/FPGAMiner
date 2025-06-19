#!/bin/bash

set -e

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing tools for Linux..."

    sudo apt update
    sudo apt install -y yosys nextpnr fasm \
        build-essential cmake git libftdi-dev \
        libboost-all-dev python3 python3-pip

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing tools for macOS..."

    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew install yosys
    mkdir -p ~/fpga-tools
    cd ~/fpga-tools
    if [ ! -d "./icestorm" ]; then
        git clone https://github.com/YosysHQ/icestorm.git
        cd icestorm && make -j$(sysctl -n hw.ncpu) && sudo make install
    fi

    if [ ! -d "./icestorm" ]; then
        git clone https://github.com/YosysHQ/nextpnr.git
        cd nextpnr
        cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local -B build
        cmake --build build -j$(nproc)
        sudo cmake --install build
    fi
    # Install Alchitry Loader
    if [ ! -d "alchitry-loader" ]; then
        echo "📥 Cloning alchitry-loader..."
        git clone https://github.com/SparkFun/Alchitry-Loader.git alchitry-loader
        cd alchitry-loader
        ./install.sh
        cd ..
    else
        echo "✅ alchitry-loader already cloned."
    fi
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "FPGA toolchain installed successfully."