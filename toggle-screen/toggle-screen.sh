#!/bin/bash

CONFIG_FILE="/tmp/togglescreen.config"
OUTPUTS=$(xrandr | grep " connected" | awk '{print $1}')

CURRENT_OUTPUT="AUTO"
if [ -e $CONFIG_FILE ]; then
    CURRENT_OUTPUT=$(cat "$CONFIG_FILE")
fi

NEXT=0
OUTPUT_SET=""
SH="xrandr "

if [ "$CURRENT_OUTPUT" = "AUTO" ]; then 
    NEXT=1
fi

for OUTPUT in ${OUTPUTS[@]}; do
    if [ -n "$OUTPUT_SET" ]; then
        SH=$SH"--output $OUTPUT --off "
    elif [ "$CURRENT_OUTPUT" = "$OUTPUT" ]; then
        SH=$SH"--output $OUTPUT --off "
        NEXT=1
    elif [ $NEXT = 1 ]; then
        SH=$SH"--output $OUTPUT --auto --primary "
        OUTPUT_SET=$OUTPUT
    fi
done

if [ ! -n "$OUTPUT_SET" ]; then
    SH="xrandr --auto"
    OUTPUT_SET="AUTO"
fi

echo "Current output: $CURRENT_OUTPUT, switching to $OUTPUT_SET"
echo "Running \"$SH\""
bash -c "$SH"
echo $OUTPUT_SET > $CONFIG_FILE
