#!/bin/bash
while read -r command; do
    output=$(eval "$command")
    echo "$output"
done < /home/main/Documents/tcs_ui_pipe/compipe
