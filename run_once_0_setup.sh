#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

brew tap homebrew/cask
brew tap homebrew/cask-eid
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
brew tap homebrew/bundle

brew install tree || true
brew install go || true
brew install k9s || true
brew install kubectx || true
brew install wget || true
brew install zsh-autosuggestions || true
brew install zsh-syntax-highlighting || true
brew install telnet || true
brew install romkatv/powerlevel10k/powerlevel10k || true

brew cask install iterm2 || true
brew cask install docker || true
brew cask install font-fira-code || true
brew cask install macdown || true
brew cask install visual-studio-code || true
brew cask install firefox || true
brew cask install karabiner-elements || true
brew cask install rectangle || true