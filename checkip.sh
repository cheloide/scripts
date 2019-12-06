#!/bin/bash

LAST_IP_FILE="$HOME/.last-ip"
LAST_IP="$( if [ -f $LAST_IP_FILE ]; then cat $LAST_IP_FILE; fi )"
CURRENT_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"


if [ $? = 0 ] &[  -n "$LAST_IP" ] & [ "$LAST_IP" != "$CURRENT_IP" ]; then
    #DO STUFF
    # echo "New IP: $CURRENT_IP"
    echo "$CURRENT_IP" > ${LAST_IP_FILE}
fi
