#!/bin/bash

USERNAME=$1

if [ $# -ne 1 ]; then
    echo ./autorice.sh USERNAME
    exit 1
fi

if [ ! -d /home/$USERNAME/.config ]; then
    mkdir /home/$USERNAME/.config
fi

ln -s /home/$USERNAME/dotfiles/fontconfig /home/$USERNAME/.config/fontconfig
