#!/bin/bash
set -e

confirm () {
    while true
    do
        echo -n "$@ [y/n] "
        read -e answer
        if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            return 1
        else
            return 0
        fi
    done
}

cd $HOME

# Download and install dotfiles
if [[ $(ls dotfiles) ]]
then
    rm -rfv dotfiles
fi 

git clone https://github.com/mrivnak/dotfiles
cp -v dotfiles/.zshrc .
cp -v dotfiles/.p10k.zsh .
cp -v dotfiles/.vimrc .
cp -v dotfiles/cat .

# Install Oh My Zsh
if [[ $(ls .oh-my-zsh) ]]
then
    rm -rfv .oh-my-zsh
fi 
CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install themes and plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Change default shell
if [[ $SHELL != $(which zsh) ]]
then
    sudo usermod -s $(which zsh) $USER
fi

# Install fonts
confirm "Do you want to install fonts?"
if [ $? -eq 1 ]
then
    mkdir -pv .fonts/Hack\ Nerd\ Font
    pushd .fonts/Hack\ Nerd\ Font
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
    unzip Hack.zip
    rm Hack.zip
    popd
fi

# Install git versions of neofetch and pfetch
confirm "Do you want to install neofetch and pfetch?"
if [ $? -eq 1 ]
then
    for ITEM in neofetch pfetch
    do

        git clone https://github.com/dylanaraps/$ITEM
        pushd $ITEM
        sudo make install
        popd
        rm -rf $ITEM
    done
fi

# Install wallpapers
confirm "Do you want to install wallpapers?"
if [ $? -eq 1 ]
then
    mkdir -pv $HOME/Pictures
    git clone https://github.com/mrivnak/os-wallpapers $HOME/Pictures/os-wallpapers
fi

zsh