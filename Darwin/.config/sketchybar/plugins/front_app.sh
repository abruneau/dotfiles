#!/usr/bin/env sh

ICON_PADDING_RIGHT=10

case $INFO in
  "Warp")
    ICON_PADDING_RIGHT=8
    ICON=
    ;;
  "Google Calendar")
    ICON_PADDING_RIGHT=8
    ICON=
    ;;
  "Discord")
    ICON=ﭮ
    ;;
  "Zoom")
    ICON_PADDING_RIGHT=11
    ICON=
    ;;
  "Finder")
    ICON=
    ;;
  "Google Chrome")
    ICON_PADDING_RIGHT=7
    ICON=
    ;;
  "Messages")
    ICON=
    ;;
  "Notion")
    ICON_PADDING_RIGHT=12
    ICON=
    ;;
  "PS Remote Play")
    ICON_PADDING_RIGHT=6
    ICON=
    ;;
  "Spotify")
    ICON=
    ;;
  *)
    # ICON=﯂
    ICON=
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT
sketchybar --set $NAME.name label="$INFO"