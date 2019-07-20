#!/bin/bash

function set_metadata {
	CUE=$1
	FLAC_FOLDER=$2
	CURRENT_DIR=`pwd`

	cd "$FLAC_FOLDER"
	cuetag "$CUE" *.flac
	cd "$CURRENT_DIR"

}

function split_flac {
	CUE=$1
	FLAC=$2
	OUTPUT_DIR=$3
	shnsplit -O always -f "$CUE" -t %n-%t -o flac "$FLAC" -d "$OUTPUT_DIR"
}

function convert_opus_128k {
	FLAC_FOLDER=$1
	BITRATE=128k

	find "$FLAC_FOLDER" -name *.flac -exec bash -c 'ffmpeg -y -i "$0" -c:a libopus -b:a $1 -vbr 2 "${0%.flac}.ogg" && rm "$0"' "{}" "$BITRATE" \;
}

function process_file_cue_flac {
    CUE=$1
    DESTINATION=${CUE%/*.cue}
	DESTINATION=${DESTINATION//*`basename "$2"`/$2}
	FLAC="${CUE%.cue}.flac"
	
	mkdir -p "$DESTINATION"

	split_flac "$CUE" "$FLAC" "$DESTINATION"
	set_metadata "$CUE" "$DESTINATION"
	convert_opus_128k "$DESTINATION"
	exit 0
}

function process_folder_flac {
	FOLDER=$1
	DESTINATION_FOLDER="$(readlink -f "$2")/$(echo $FOLDER | sed 's,^/.*/,,')"
	echo "$DESTINATION_FOLDER"
	SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/functions.sh

	echo $SCRIPT_DIR

	find "$FOLDER" -name *.cue -exec bash -c '. "$0" && process_file_cue_flac "$1" "$2"' "$SCRIPT_DIR" "{}" "$DESTINATION_FOLDER"  \;

}