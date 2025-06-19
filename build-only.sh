#!/bin/bash

set -e
set -u

IMAGE_NAME=fpga-toolchain
CONTAINER_NAME=fpga-builder
PROJECT_DIR=$(pwd)

echo "Build project in Docker..."

# Check if the image exists; if not, build it
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Docker image not found. Building it..."
    docker buildx build --platform linux/amd64 -t $IMAGE_NAME docker/
else
    echo "Docker image already built."
fi

# Check if the build directory exists; if not, make it
if [ ! -d "$PROJECT_DIR/build" ]; then
    echo "Creating the build directory..."
    mkdir "$PROJECT_DIR/build"
fi

# Run the container, mount the current directory, and build inside it
docker run --rm -it \
  --name $CONTAINER_NAME \
  -v "$PROJECT_DIR":/project \
  -w /project \
  $IMAGE_NAME \
  bash -c "make"

echo "Build complete!"