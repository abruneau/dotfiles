#!/bin/bash

setup() {

    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo -n "Installing Homebrew"
        until
            brew --version &
            >/dev/null
        do
            sleep 5
            echo -n "."
        done
        echo ""
        echo "Homebrew installation completed"

        UNAME_MACHINE="$(/usr/bin/uname -m)"

        if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
            # On ARM macOS, this script installs to /opt/homebrew only
            HOMEBREW_PREFIX="/opt/homebrew"
            HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
        else
            # On Intel macOS, this script installs to /usr/local only
            HOMEBREW_PREFIX="/usr/local"
            HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
        fi
        (
            echo
            echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\""
        ) >>${HOME}/.zprofile
        eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
    fi

    # Update Homebrew recipes
    brew update

    # Install all our dependencies with bundle (See Brewfile)
    brew tap homebrew/bundle
    brew bundle --no-lock --no-upgrade --file Darwin/Brewfile

    # Setup Iterm
    wget http://ethanschoonover.com/solarized/files/solarized.zip && unzip solarized.zip
    open solarized/iterm2-colors-solarized/Solarized\ Dark.itermcolors
    rm -rf solarized && rm solarized.zip

    # Font
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /Library/Fonts

    # Setup files
    rm -rf ~/.config
    ln -s $(pwd)/Darwin/.config ~/.config
    rm -rf ~/.zshrc
    ln -s $(pwd)/Darwin/zsh/.zshrc ~/.zshrc
    cp $(pwd)/Darwin/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
    rm ~/.p10k.zsh
    ln -s $(pwd)/shared/zsh/.p10k.zsh ~/.p10k.zsh
    rm -rf ~/.oh-my-zsh/custom/*
    ln -s $(pwd)/shared/zsh/custom/* ~/.oh-my-zsh/custom/

    # Store MD5s
    echo "BREWFILE=$(md5 -q Darwin/Brewfile)" >>~/.dot
    echo "MACOS=$(md5 -q Darwin/.macos)" >>~/.dot

    source $(pwd)/Darwin/asdf.sh
    source $(pwd)/Darwin/.config/sketchybar/helpers/install.sh

    # Set macOS preferences
    # We will run this last because this will reload the shell
    source Darwin/.macos
}

update() {
    echo "Updating your Mac..."

    git pull

    git submodule update --remote

    if cat ~/.dot | grep -q $(md5 -q Darwin/Brewfile); then
        echo "Brew up to date"
    else
        echo "Updating Brewfile..."
        brew bundle --no-lock --no-upgrade --file Darwin/Brewfile
        sed -i.back "s/^BREWFILE=.*/BREWFILE=$(md5 -q Darwin\/Brewfile)/" ~/.dot
    fi

    if cat ~/.dot | grep -q $(md5 -q Darwin\/.macos); then
        echo "Mac OS config up to date"
    else
        echo "Updating Mac OS config"
        source Darwin/.macos
        sed -i.back "s/^MACOS=.*/MACOS=$(md5 -q Darwin\/.macos)/" ~/.dot
    fi
}
