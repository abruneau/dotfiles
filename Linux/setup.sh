#!/usr/bin/env bash

declare run="silentRun"

function silentRun() {
    echo $1;
    "${@:2}" >/dev/null;
}

function verboseRun() {
    echo $1;
    "${@:2}";
}

# Somewhere else in your script's setup, do something like this
while [[ $# > 0 ]]; do
    case "$1" in
        -v|--verbose) run='verboseRun'; ;;
    esac
    shift;
done

function installZSH() {
    sudo apt install zsh curl git -y;
    chsh -s $(which zsh);

    # Install OhMyZsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Instal powerlevel10k
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    mkdir ~/.fonts
    cp *.ttf ~/.fonts
    rm *.ttf

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i -e 's/ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/'
    echo "# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh." >> ~/.zshrc
    echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc
    ln ../shared/zsh/.p10k.zsh ~/.p10k.zsh

    ln -s ../shared/zsh/custom/* ~/.oh-my-zsh/custom/
    ln -s ./zsh/custom/* ~/.oh-my-zsh/custom/
}


$run "Seting up ZSH" installZSH

echo "Restart is required to finish setup"
while true; do
    read -p "Restart now?" yn
    case $yn in
        [Yy]* ) reboot; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done