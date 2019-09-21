#!/bin/sh

_time() {
	echo -n " $(date '+%H:%M')"
}

_date() {
	echo -n " $(date '+%Y-%m-%d')"
}

_disk_usage_home() {
	echo -n " $(df -h $HOME | awk 'NR==2 {print $4}')"
}

_disk_usage_storage() {
	echo -n " $(df -h /media/files | awk 'NR==2 {print $4}')"
}

_volume() {
	echo -n " $(amixer sget Master | awk -F"[][]" '/dB/ { print $2 }')"
}

_pacman() {
	updates="$(cat /tmp/pacman_updates)"
	if [ "$updates" -gt 0 ]; then
		echo -n " $updates  "
	fi
}

if [ "$(cat /etc/hostname)" = "laptop" ]; then
	if [ "$1" = "refresh" ]; then
		xsetroot -name "$(_pacman)$(_volume)  $(_disk_usage_home)  $(_date)  $(_time)"
	else
		while true; do
			xsetroot -name "$(_pacman)$(_volume)  $(_disk_usage_home)  $(_date)  $(_time)"
			sleep 1m
		done
	fi
elif [ "$(cat /etc/hostname)" = "desktop" ]; then
	if [ "$1" = "refresh" ]; then
		xsetroot -name "$(_pacman)$(_volume)  $(_disk_usage_storage)  $(_disk_usage_home)  $(_date)  $(_time)"
	else
		while true; do
			xsetroot -name "$(_pacman)$(_volume)  $(_disk_usage_storage)  $(_disk_usage_home)  $(_date)  $(_time)"
			sleep 1m
		done
	fi
elif [ "$(cat /etc/hostname)" = "vm" ]; then
	if [ "$1" = "refresh" ]; then
		xsetroot -name "$(_pacman)$(_disk_usage_home)  $(_date)  $(_time)"
	else
		while true; do
			xsetroot -name "$(_pacman)$(_disk_usage_home)  $(_date)  $(_time)"
			sleep 1m
		done
	fi
fi
