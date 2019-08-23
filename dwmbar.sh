#!/bin/sh

STATUS=""

_time() {

	_time="  $(date '+%H:%M')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_time"
	else
		STATUS="$STATUS  $_time"
	fi
}

_date() {

	_date="  $(date '+%Y-%m-%d')"

	if [ "$STATUS" = "" ]; then
		STATUS="$_date"
	else
		STATUS="$STATUS  $_date"
	fi
}

_date
_time

echo "$STATUS"
