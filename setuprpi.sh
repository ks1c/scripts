#!/bin/bash

USERNAME=$1
HOSTNAME=$1

option_handler() {

	i=1
	for option in $@; do

		if [ $option == "-u" ] || [ $option == "--username" ]; then
			let next=${i}+1
			echo $'$next'
		fi

		let i=${i}+1
	done
}

option_handler $@
