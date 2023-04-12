#!/bin/sh

setup() {
    echo "Setting up your Mac..."
    if type xcode-select >&- && xpath=$(xcode-select --print-path) &&
    test -d "${xpath}" && test -x "${xpath}"; then
        echo "Command Line Tool already installed"
    else
        xcode-select --install
    fi
    
    # Setup files
    ln -s $(pwd)/Darwin/.config ~/.config
    cp $(pwd)/Darwin/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
    
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
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i -e 's/ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc
    echo "# To customize prompt, run p10k configure or edit ~/.p10k.zsh." >> ~/.zshrc
    echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
    ln -s $(pwd)/shared/zsh/.p10k.zsh ~/.p10k.zsh
    
    ln -s $(pwd)/shared/zsh/custom/* ~/.oh-my-zsh/custom/
    
    git clone https://github.com/blimmer/zsh-aws-vault.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
    
    # Font
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /Library/Fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /Library/Fonts
    
    # Setup VSCode
    source Darwin/.vscode
    
    # Store MD5s
    echo "BREWFILE=$(md5 -q Darwin/Brewfile)" >>~/.dotfile
    echo "VSCODE=$(md5 -q Darwin/.vscode)" >>~/.dotfile
    echo "MACOS=$(md5 -q Darwin/.macos)" >>~/.dotfile
    
    # Set macOS preferences
    # We will run this last because this will reload the shell
    source Darwin/.macos
}

update() {
    echo "Updating your Mac..."
    
    if cat ~/.dotfile | grep -q $(md5 -q Darwin/Brewfile); then
        echo "Brew up to date"
    else
        echo "Updating Brewfile..."
        brew bundle --no-lock --no-upgrade --file Darwin/Brewfile
        sed -i.back "s/^BREWFILE=.*/BREWFILE=$(md5 -q Darwin\/Brewfile)/" ~/.dotfile
    fi
    
    if cat ~/.dotfile | grep -q $(md5 -q Darwin/.vscode); then
        echo "VSCode up to date"
    else
        echo "Updating VSCode pluggins ..."
        source .vscode
        sed -i.back "s/^VSCODE=.*/VSCODE=$(md5 -q Darwin\/.vscode)/" ~/.dotfile
    fi
    
    if cat ~/.dotfile | grep -q $(md5 -q Darwin\/.macos); then
        echo "Mac OS config up to date"
    else
        echo "Updating Mac OS config"
        source .macos
        sed -i.back "s/^MACOS=.*/MACOS=$(md5 -q Darwin\/.macos)/" ~/.dotfile
    fi
}