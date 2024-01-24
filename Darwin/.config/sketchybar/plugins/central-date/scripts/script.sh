#!/bin/zsh

date=$(date +'%A, %B %-d')
uppercase_date=$(echo $date | tr '[:lower:]' '[:upper:]')

sketchybar --set date label="$uppercase_date"

time=$(date '+%H:%M')

sketchybar --set time label="$time"