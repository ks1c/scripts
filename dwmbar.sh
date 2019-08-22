#!/bin/sh

check_updates() {

	updates=$(checkupdates)

	if [ "$updates" != "" ]; then
		updates=" $(echo "$updates" | wc -l)  "
	else
		updates=""
	fi
}
check_updates
xsetroot -name "$updates"
