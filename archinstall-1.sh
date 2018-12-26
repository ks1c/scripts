#!/bin/bash

#Verifica se o primeiro e segundo argumentos sao vazios. -e interpreta \n
if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ] || [ "$4" == "" ] || [ "$5" == "" ]; then
echo "linux_partition efi_partition user password notebook/desktop"
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
if [ "$5" == "desktop" ]; then
pacstrap /mnt base base-devel grub efibootmgr os-prober wpa_supplicant
fi
if [ "$5" == "notebook" ]; then
pacstrap /mnt base base-devel grub efibootmgr os-prober wpa_supplicant git bumblebee nvidia nvidia-settings xf86-video-intel xorg i3-gaps i3status dmenu xterm xorg-xinit
fi
genfstab -U /mnt > /mnt/etc/fstab
echo "pronto."

echo -n "entrando em chroot"
cat << EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $4; echo $4; } | passwd
useradd -m -G wheel $3
{ echo $4; echo $4; } | passwd $3
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

if [ "$5" == "notebook" ]; then
gpasswd -a $3 bumblebee
systemctl enable bumblebeed.service
fi

cp /etc/X11/xinit/xinitrc /home/$3/.xinitrc
chown $3 /home/$3/.xinitrc
cd /home/$3/
git clone http://github.com/ks1c/scripts
chown $3 -R scripts

if [ "$5" == "desktop" ]; then
fi

EOF
reboot

# echo Y | pacman -S bumblebee
# echo Y | pacman -S nvidia
# echo Y | pacman -S nvidia-settings
# echo Y | pacman -S xf86-video-intel
# { echo ""; echo Y; } | pacman -S xorg
# echo Y | pacman -S i3-gaps
# echo Y | pacman -S i3status
# echo Y | pacman -S dmenu
# echo Y | pacman -S xterm
# echo Y | pacman -S xorg-xinit


