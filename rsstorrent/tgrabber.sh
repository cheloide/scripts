#!/bin/bash

#Depends on curl, xmlstarlet, deluge-console >= 2.0.0

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )


VARS_PATH=$SCRIPT_DIR/vars
SHOWS_PATH=$SCRIPT_DIR/shows
ADDED_PATH=$SCRIPT_DIR/shows

. $VARS_PATH

add_torrent() {
    TORRENT_URL=$1
    SHOW_NAME=$2
    grep "$TORRENT_URL" added -q

    if [ ! $? -eq 0 ]; then
        echo Adding torrent $TORRENT_URL

        TORRENT_FILE_PATH=$TEMP_DIR/$(date +%s%N).torrent
        TORRENT_MOVE_COMPLETE_PATH="$DELUGE_DOWNLOAD_BASE_PATH/$SHOW_NAME"

        wget -q -O $TORRENT_FILE_PATH "$TORRENT_URL" 
        deluge-console "connect $DELUGE_HOST $DELUGE_USERNAME $DELUGE_PASSWORD; add $TORRENT_FILE_PATH -m \"$TORRENT_MOVE_COMPLETE_PATH\"; exit"

        if [ $? -eq 0 ]; then
            echo $TORRENT_URL >> $ADDED_PATH
        fi
    else
        echo Torrent $TORRENT_URL exists
    fi
}

get_torrents() {
    SHOW_NAME="$PREFIX $1"
    echo "$SHOW_NAME"
    XPATH='/rss/channel/item[contains(title,"'$1'")]/link'
    xmlstarlet sel -t -v "$XPATH" "$RSS_FILE_PATH" | while IFS= read link || [ -n "$link" ]; do add_torrent "$link" "$SHOW_NAME" ; done
    echo
}

TEMP_DIR=$(mktemp -d)

RSS_FILE_PATH=$TEMP_DIR/rss.xml
wget -q -O "$RSS_FILE_PATH" "$RSS_URL"

while IFS= read -r line || [ -n "$line" ]; do get_torrents "$line" ; done < $SHOWS_PATH

rm -rf $TEMP_DIR
