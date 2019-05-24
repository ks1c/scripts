#!/bin/bash

CMD=$(echo -e "power off\nreboot\nlock\nlog off")

INPUT=$(echo -e "$CMD" | dmenu -nb Black -fn ':bold:pixelsize=15')

case "$INPUT" in
	"power off")
		poweroff
		;;
	"reboot")
		reboot
		;;
	"lock")
		lock
		;;
	"log off")
		killall i3
		;;
	*)
		exit
esac
