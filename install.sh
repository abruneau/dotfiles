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
    # Check if Command Line Tools are installed
    if
        ! xcode-select -p &
        >/dev/null
    then
        echo "Installing Command Line Tools..."
        xcode-select --install

        # Wait until the Command Line Tools are installed
        until
            xcode-select -p &
            >/dev/null
        do
            sleep 5
            echo -n "."
        done
        echo ""
        echo "Command Line Tools installation completed"
    else
        echo "Command Line Tools already installed"
    fi

elif [ "$OS" = "RedHat" ]; then
    sudo yum install git -y

elif [ "$OS" = "Debian" ]; then
    sudo apt install git-all -y

elif [ "$OS" = "SUSE" ]; then
    sudo dnf install git-all -y
fi

git clone --recurse-submodules https://github.com/abruneau/dotfiles.git .dotfiles

cd .dotfiles

if [ "$DEV" = "true" ]; then
    git checkout dev
    git pull
fi

./run.sh
