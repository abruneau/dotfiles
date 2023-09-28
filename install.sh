#!/usr/bin/env bash

DEV="${DEV:-false}"

if [ "$(uname)" = "Darwin" ]; then
    OS="Darwin"
elif [ -f /etc/debian_version ]; then
    OS="Debian"
elif [ -f /etc/redhat-release ]; then
    OS="RedHat"
# Some newer distros like Amazon may not have a redhat-release file
elif [ -f /etc/system-release ]; then
    OS="RedHat"
# Arista is based off of Fedora14/18 but do not have /etc/redhat-release
elif [ -f /etc/Eos-release ]; then
    OS="RedHat"
# openSUSE and SUSE use /etc/SuSE-release or /etc/os-release
elif [ -f /etc/SuSE-release ]; then
    OS="SUSE"
fi

# installing command line tool to have git cmd
if [ "$(uname)" == "Darwin" ]; then
    if type xcode-select >&- && xpath=$(xcode-select --print-path) &&
        test -d "${xpath}" && test -x "${xpath}"; then
        echo "Command Line Tool already installed"
    else
        xcode-select --install
    fi

elif [ "$OS" = "RedHat" ]; then
    sudo yum install git -y

elif [ "$OS" = "Debian" ]; then
    sudo apt install git-all -y

elif [ "$OS" = "SUSE" ]; then
    sudo dnf install git-all -y
fi

git clone https://github.com/abruneau/dotfiles.git .dot

cd .dot

if [ "$DEV" = "true" ]; then
    git checkout dev
    git pull
fi

./run.sh