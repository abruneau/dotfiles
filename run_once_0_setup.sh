#!/bin/sh

setutMac() {
    echo "Setting up your Mac..."
    if type xcode-select >&- && xpath=$(xcode-select --print-path) &&
        test -d "${xpath}" && test -x "${xpath}"; then
        echo "Command Line Tool already installed"
    else
        xcode-select --install
    fi

    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Update Homebrew recipes
    brew update

    # Install all our dependencies with bundle (See Brewfile)
    brew tap homebrew/bundle
    brew bundle --no-lock --no-upgrade

    # Setup Iterm
    wget http://ethanschoonover.com/solarized/files/solarized.zip && unzip solarized.zip
    open solarized/iterm2-colors-solarized/Solarized\ Dark.itermcolors
    rm -rf solarized && rm solarized.zip

    # Font
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /Library/Fonts

    # Setup VSCode
    source $(chezmoi source-path)/.vscode

    # Store MD5s
    echo "BREWFILE=$(md5 -q $(chezmoi source-path)/Brewfile)" >>~/.dotfile
    echo "VSCODE=$(md5 -q $(chezmoi source-path)/.vscode)" >>~/.dotfile
    echo "MACOS=$(md5 -q $(chezmoi source-path)/.macos)" >>~/.dotfile

    # Set macOS preferences
    # We will run this last because this will reload the shell
    source $(chezmoi source-path)/.macos
}

if [ "$(uname)" == "Darwin" ]; then
    setutMac
fi
