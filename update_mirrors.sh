#!/bin/bash

CONTENT=$(cat /etc/pacman.d/mirrorlist)
BRMIRRORS=$(awk '/## Brazil/{getline; print}' /etc/pacman.d/mirrorlist)
echo "$BRMIRRORS" >/etc/pacman.d/mirrorlist
echo "$CONTENT" >>/etc/pacman.d/mirrorlist
