#!/bin/bash

IMAGE_NAME=$1
CONTAINER_NAME=$2

echo "stopping $IMAGE_NAME ($CONTAINER_NAME)"
docker stop $CONTAINER_NAME