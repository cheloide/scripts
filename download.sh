#!/bin/bash



function list-download {
	FILE=$1
    while read line; do
	if [[ ! $line =~ ^\s*#.* ]]; then
	        url="${line%@*}"
        	dest="${line//$url@}"
	        echo URL $url >> DEST $dest
			aria2c -x 16 --continue=true --dir="${dest%/*}" -o "$(basename "$dest")" "$url"
		# sleep 5
		if [ $? -eq 0 ]; then
			rpl "${line}" "#${line}" "$FILE"
		fi
	fi
    done < "$FILE"

}
