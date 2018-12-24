#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
echo "interface ssid psk"
exit 1
fi

echo "network={ssid="$2" psk="$3"}" > /etc/wpa_supplicant/wifi

wpa_supplicant -i $1 -c /etc/wpa_supplicant/wifi
dhcpcd