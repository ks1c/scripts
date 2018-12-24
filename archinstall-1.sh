#!/bin/bash

#Verifica se o primeiro e segundo argumentos sao vazios. -e interpreta \n
if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ] || [ "$4" == "" ]; then
echo "linux_partition efi_partition user password"
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

#read -p "Continue? (y/n)" choice
#case "$choice" in
#	y ) ;;
#	n ) exit 1;;
#	* ) echo -n "invalid";;
#esac

echo -n "Instalando arch-linux..."
pacstrap /mnt base base-devel grub efibootmgr os-prober wpa_supplicant
genfstab -U /mnt > /mnt/etc/fstab
echo "pronto."

echo -n "entrando em chroot"
cat << EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $4; echo $4; } | passwd
useradd -m -G wheel $3
{ echo $4; echo $4; } | passwd $3
echo %wheel ALL=(ALL) ALL >> /etc/sudoers
EOF


