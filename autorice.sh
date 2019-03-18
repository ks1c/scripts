#!/bin/bash

USERNAME=$1

if [ $# -ne 1 ]; then
    echo ./autorice.sh USERNAME
    exit 1
fi

if [ ! -d /home/$USERNAME/.config ]; then
    mkdir /home/$USERNAME/.config
fi

rm -rf /home/$USERNAME/.config/fontconfig
ln -s /home/$USERNAME/dotfiles/fontconfig /home/$USERNAME/.config/fontconfig

rm -rf /home/$USERNAME/.config/fish
ln -s /home/$USERNAME/dotfiles/fish /home/$USERNAME/.config/fish

rm -rf /home/$USERNAME/.bashrc
ln -s /home/$USERNAME/dotfiles/.bashrc /home/$USERNAME/.bashrc

rm -rf /home/$USERNAME/.bash_profile
ln -s /home/$USERNAME/dotfiles/.bash_profile /home/$USERNAME/.bash_profile

rm -rf /home/$USERNAME/.gtkrc-2.0
ln -s /home/$USERNAME/dotfiles/.gtkrc-2.0 /home/$USERNAME/.gtkrc-2.0

rm -rf /home/$USERNAME/.config/gtk-3.0/
ln -s /home/$USERNAME/dotfiles/gtk-3.0 /home/$USERNAME/.config/gtk-3.0/
