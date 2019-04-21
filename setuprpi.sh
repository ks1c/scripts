#!/bin/bash

RICE=false

HOSTNAME="rbp"

USAGE="\nUSAGE: ./setuprbp.sh --username=username --password=password\n"

if [ $# -ne 2 ]; then
	echo -e $USAGE
	exit
fi


for i in "$@"; do
	case $i in
		-u=*|--username=*)
			USERNAME="${i#*=}"
			;;
		-p=*|--password=*)
			PASSWORD="${i#*=}"
			;;
		--rice)
			RICE=true
			;;
	esac
done

add_to_package_list() {
	PACKAGE_LIST=$PACKAGE_LIST" $1"
}

add_to_package_list sudo

if [ ! $RICE ]; then

	loadkeys br-abnt2
	pacman-key --init
	pacman-key --populate archlinuxarm
	timedatectl set-ntp true
	ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
	hwclock --systohc
	echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
	echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
	locale-gen
	echo LANG=pt_BR.UTF-8 > /etc/locale.conf
	echo KEYMAP=br-abnt2 > /etc/vconsole.conf
	echo $HOSTNAME > /etc/hostname
	{ echo $PASSWORD; echo $PASSWORD; } | passwd

	echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Identifier "system-keyboard"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'MatchIsKeyboard "on"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Option "XkbLayout" "br"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Option "XkbModel" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'Option "XkbVariant" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
	echo 'EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf

	userdel -r alarm
	useradd -m -G wheel $USERNAME
	{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
	echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

	sed -i 's/#Color/Color/g' /etc/pacman.conf
	pacman -Syyu
	pacman --noconfirm --needed -S $PACKAGE_LIST

	cd /home/$USERNAME/
	git clone http://github.com/ks1c/scripts
	git clone http://github.com/ks1c/dotfiles
	chown $USERNAME -R /home/$USERNAME/
	chgrp $USERNAME -R /home/$USERNAME/
fi
