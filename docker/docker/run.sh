#!/bin/bash

IMAGE_NAME=$1
CONTAINER_NAME=$2
ENV=$3
PORTS=$4

    if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    if [ "$(docker ps -aq -f status=running -f name=$CONTAINER_NAME)" ]; then
        echo 'Container already running'
    elif [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
        echo "running $IMAGE_NAME ($CONTAINER_NAME)"
        docker start $CONTAINER_NAME;
    else
        echo "running $IMAGE_NAME ($CONTAINER_NAME)"
        bash -c "docker run -d --name $CONTAINER_NAME $PORTS $ENV $IMAGE_NAME"
    fi
else
        bash -c "docker run -d --name $CONTAINER_NAME $PORTS $ENV $IMAGE_NAME"
fi
