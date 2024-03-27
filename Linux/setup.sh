#!/usr/bin/env bash

function installZSH() {
    sudo apt install zsh curl git -y;

    # Install OhMyZsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Instal powerlevel10k
    mkdir ~/.fonts
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.fonts/
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/.fonts/
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/.fonts/
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/.fonts/

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i -e 's/ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc
    echo "# To customize prompt, run p10k configure or edit ~/.p10k.zsh." >> ~/.zshrc
    echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
    ln -s $(pwd)/shared/zsh/.p10k.zsh ~/.p10k.zsh

    ln -s $(pwd)/shared/zsh/custom/* ~/.oh-my-zsh/custom/
    ln -s $(pwd)/Linux/zsh/custom/* ~/.oh-my-zsh/custom/

    sudo chsh -s $(which zsh) $USER
}

function setup() {
    echo "Seting up ZSH" 
    installZSH

    touch ~/.dotfile
}

function update() {
    git pull

    git submodule update --remote
}