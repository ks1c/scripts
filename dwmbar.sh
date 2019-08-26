#!/bin/sh

STATUS=""

_time() {

	_time=" $(date '+%H:%M')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_time"
	else
		STATUS="$STATUS  $_time"
	fi
}

_date() {

	_date=" $(date '+%Y-%m-%d')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_date"
	else
		STATUS="$STATUS  $_date"
	fi
}

_disk_usage_home() {

	_disk_usage_home=" $(df -h $HOME | awk 'NR==2 {print $4}')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_disk_usage_home"
	else
		STATUS="$STATUS  $_disk_usage_home"
	fi
}

_disk_usage_storage() {

	_disk_usage_storage=" $(df -h /media/files | awk 'NR==2 {print $4}')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_disk_usage_storage"
	else
		STATUS="$STATUS  $_disk_usage_storage"
	fi
}

_updates() {

	_updates=" 5"

	if [ "$STATUS" = "" ]; then
		STATUS="$_updates"
	else
		STATUS="$STATUS  $_updates"
	fi
}

_volume() {

	_volume=" $(amixer sget Master | awk -F"[][]" '/dB/ { print $2 }')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_volume"
	else
		STATUS="$STATUS  $_volume"
	fi
}

[ -f ~/.tmprc ] && source ~/.tmprc

if [ $1 = "refresh" ]; then

	STATUS=""
	#_updates
	_volume
	_disk_usage_storage
	_disk_usage_home
	_date
	_time
	xsetroot -name "$STATUS"

else

	while true; do

		STATUS=""
		#_updates
		_volume
		_disk_usage_storage
		_disk_usage_home
		_date
		_time
		xsetroot -name "$STATUS"
		sleep 1m
	done
fi
