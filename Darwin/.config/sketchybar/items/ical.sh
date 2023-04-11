#!/usr/bin/env sh

POPUP_CLICK_SCRIPT="sketchybar --set ical popup.drawing=toggle"

sketchybar  --add       item            ical right                            \
            --set       ical            update_freq=180                       \
                                        icon=􀉉                                \
                                        icon.align=right                      \
                                        popup.align=right                     \
                                        popup.height=20                       \
                                        background.padding_right=-2           \
                                        background.padding_left=10            \
                                        y_offset=-10                          \
                                        script="$PLUGIN_DIR/ical.sh"          \
                                        click_script="$POPUP_CLICK_SCRIPT"    \
                                                                              \
            --add       item            ical.details popup.ical               \
            --set       ical.details    drawing=off                           \
                                        background.corner_radius=12           \
                                        icon.font="$FONT:Bold:14.0"           \
                                        icon.background.height=2              \
                                        icon.background.y_offset=-12          \
            --subscribe ical            mouse.entered                         \
                                        mouse.exited                          \
                                        mouse.exited.global
