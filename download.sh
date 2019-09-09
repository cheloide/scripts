#!/bin/bash



function list-download {
    while read line; do
        url="${line%@*}"
        dest="${line//$url@}"
        # echo "$url >> $dest" ;
        axel -n 10 "$url" -c -o "$dest"
    done < "${1}"

}