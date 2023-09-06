#!/bin/bash
while read -r command; do
    output=$(eval "$command")
    echo "$output"
done < /home/tch/apps/tcs_ui/tcs_ui_pipe/compipe
