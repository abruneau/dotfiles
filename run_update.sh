#!/bin/bash

updateMac() {
    echo "Updating your Mac..."

    if cat ~/.dotfile | grep -q $(md5 -q $(chezmoi source-path)/Brewfile); then
        echo "Brew up to date"
    else
        echo "Updating Brewfile..."
        brew bundle --no-lock --no-upgrade --file $(chezmoi source-path)/Brewfile
        sed -i.back "s/^BREWFILE=.*/BREWFILE=$(md5 -q $(chezmoi source-path)\/Brewfile)/" ~/.dotfile
    fi

    if cat ~/.dotfile | grep -q $(md5 -q $(chezmoi source-path)/.vscode); then
        echo "VSCode up to date"
    else
        echo "Updating VSCode pluggins ..."
        source .vscode
        sed -i.back "s/^VSCODE=.*/VSCODE=$(md5 -q $(chezmoi source-path)\/.vscode)/" ~/.dotfile
    fi

    if cat ~/.dotfile | grep -q $(md5 -q $(chezmoi source-path)\/.macos); then
        echo "Mac OS config up to date"
    else
        echo "Updating Mac OS config"
        source .macos
        sed -i.back "s/^MACOS=.*/MACOS=$(md5 -q $(chezmoi source-path)\/.macos)/" ~/.dotfile
    fi
}

if [ "$(uname)" == "Darwin" ]; then
    updateMac
fi
