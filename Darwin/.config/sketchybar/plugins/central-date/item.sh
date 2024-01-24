#!/usr/bin/env bash

# font size of the date
DATE_FONT_SIZE=30

# font size of the time
TIME_FONT_SIZE=120

# color of the text
COLOR=0xb0ffffff

# width of each item
WIDTH=400

# y offset from the top of the screen
Y_OFFSET=330

# update frequency
UPDATE_FREQ=20

# vertical padding between the date and the time
VERT_PADDING=50

###############################################################################

# the placeholder item where popups will be drawn from
sketchybar --add item placeholder center \
    --set placeholder \
    script="$PLUGIN_DIR/central-date/scripts/script.sh" \
    update_freq=$UPDATE_FREQ \
    popup.drawing=on \
    popup.topmost=off \
    popup.y_offset=$Y_OFFSET \
    popup.align=center \
    popup.height=$VERT_PADDING \
    popup.background.color=0x00000000 \
    popup.background.border_color=0x00000000

# defaults shared between the date and time properties
sketchybar --default \
    label.color=$COLOR \
    width=$WIDTH \
    align=center

# date item
sketchybar \
    --add item date popup.placeholder \
    --set date \
    label.font="SF Pro:Bold:$DATE_FONT_SIZE"

# time item
sketchybar \
    --add item time popup.placeholder \
    --set time \
    label.font="SF Pro:Bold:$TIME_FONT_SIZE"
