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
pacstrap /mnt base base-devel grub efibootmgr os-prober wpa_supplicant git bbswitch bumblebee nvidia nvidia-settings xf86-video-intel xorg rxvt-unicode dmenu i3lock perl-json-xs perl-anyevent-i3 i3-gaps i3status acpi alsa-utils i3blocks xorg-xinit flameshot rofi neofetch compton ttf-inconsolata ttf-croscore noto-fonts
fi
genfstab -U /mnt >> /mnt/etc/fstab
echo "pronto."

echo -n "entrando em chroot"
if [ "$5" == "notebook" ]; then
cat << EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $4; echo $4; } | passwd
useradd -m -G wheel $3
{ echo $4; echo $4; } | passwd $3
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo archlinux >> /etc/hostname
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo pt_BR ISO-8859-1 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

cd /home/$3/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $3 -R /home/$3/

gpasswd -a $3 bumblebee
systemctl enable bumblebeed.service
EOF
fi
reboot


