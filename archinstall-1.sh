#!/bin/bash

#Verifica se o primeiro e segundo argumentos sao vazios. -e interpreta \n
if [ "$1" == "" ] || [ "$2" == "" ]; then
echo "-linux_partition -efi_partition"
exit 1
fi

echo y | pacman -S reflector

#Atualiza relógio
timedatectl set-ntp true

echo -n "Atualizando mirrorlist..."
reflector --country Brazil --protocol http --sort rate --save /etc/pacman.d/mirrorlist
reflector --latest 50 --number 20 --protocol http --sort rate >> /etc/pacman.d/mirrorlist 
echo "pronto."

echo -n "Formatando particao linux..."
echo y | mkfs.ext4 $1
echo "pronto."

echo -n "Montando particao linux..."
mount $1 /mnt
echo "pronto."

echo -n "Montando particao UFI..."
mkdir /mnt/boot
mount $2 /mnt/boot
echo "pronto."

read -p "Continue? (y/n)" choice
case "$choice" in
	y ) ;;
	n ) exit 1;;
	* ) echo -n "invalid";;
esac

echo -n "Instalando arch-linux..."
pacstrap /mnt base base-devel grub efibootmgr os-prober
genfstab -U /mnt > /mnt/etc/fstab
echo "pronto."




