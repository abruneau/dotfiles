#!/usr/bin/env bash


os=$(uname)

if [ -f $os/setup.sh ]; then
    source $os/setup.sh
else
    echo "No setup file find for ${os} system"
fi

if [ -f ~/.dotfile ]; then
    echo "Updating system"

    update
else
    echo "Seting up system"
    setup
fi


