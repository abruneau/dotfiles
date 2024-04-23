#!/bin/sh

setup() {
    echo "Setting up your Mac..."
    if type xcode-select >&- && xpath=$(xcode-select --print-path) &&
    test -d "${xpath}" && test -x "${xpath}"; then
        echo "Command Line Tool already installed"
    else
        xcode-select --install
    fi
    
    
    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        UNAME_MACHINE="$(/usr/bin/uname -m)"
        
        if [[ "${UNAME_MACHINE}" == "arm64" ]]
        then
            # On ARM macOS, this script installs to /opt/homebrew only
            HOMEBREW_PREFIX="/opt/homebrew"
            HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
        else
            # On Intel macOS, this script installs to /usr/local only
            HOMEBREW_PREFIX="/usr/local"
            HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
        fi
        (echo; echo 'eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"') >> ${HOME}/.zprofile
        eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
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
    
    ln -s $(pwd)/shared/zsh/custom/* ~/.oh-my-zsh/custom/
    ln -s $(pwd)/shared/zsh/.p10k.zsh ~/.p10k.zsh
    
    git clone https://github.com/blimmer/zsh-aws-vault.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-aws-vault
    
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
    
    # Setup VSCode
    source Darwin/.vscode

    # Install NeoVim
    nvim --headless +q
    
    # Store MD5s
    echo "BREWFILE=$(md5 -q Darwin/Brewfile)" >>~/.dot
    echo "VSCODE=$(md5 -q Darwin/.vscode)" >>~/.dot
    echo "MACOS=$(md5 -q Darwin/.macos)" >>~/.dot
    
    source $(pwd)/Darwin/asdf.sh

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
    
    if cat ~/.dot | grep -q $(md5 -q Darwin/.vscode); then
        echo "VSCode up to date"
    else
        echo "Updating VSCode pluggins ..."
        source .vscode
        sed -i.back "s/^VSCODE=.*/VSCODE=$(md5 -q Darwin\/.vscode)/" ~/.dot
    fi
    
    if cat ~/.dot | grep -q $(md5 -q Darwin\/.macos); then
        echo "Mac OS config up to date"
    else
        echo "Updating Mac OS config"
        source Darwin/.macos
        sed -i.back "s/^MACOS=.*/MACOS=$(md5 -q Darwin\/.macos)/" ~/.dot
    fi
}
