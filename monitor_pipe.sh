#!/bin/bash
while read -r command; do
    output=$(eval "$command")
    echo "$output"
done < /home/tch/Documents/tcs_ui_pipe/compipe
