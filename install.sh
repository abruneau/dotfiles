#!/bin/bash

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

# Function to check if Xcode Command Line Tools are installed
check_xcode_cli_installed() {
    xcode-select -p &>/dev/null
    return $?
}

# Install Xcode Command Line Tools if not installed
install_xcode_cli() {
    echo "Checking for Xcode Command Line Tools..."
    if check_xcode_cli_installed; then
        echo "Xcode Command Line Tools are already installed."
    else
        echo "Xcode Command Line Tools not found. Starting installation..."
        xcode-select --install

        # Wait for the installation to complete
        echo "Waiting for Xcode Command Line Tools to finish installing..."
        until check_xcode_cli_installed; do
            sleep 5
            echo -n "."
        done

        echo "Xcode Command Line Tools installation completed."
    fi
}

# installing command line tool to have git cmd
if [ "$(uname)" == "Darwin" ]; then
    install_xcode_cli
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
