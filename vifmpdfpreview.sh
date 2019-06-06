#!/bin/bash
#[ -f $1.jpg ] || gs -sDEVICE=jpeg -o $1.jpg -sPAPERSIZE=a4 $1 >/dev/null
gs -sDEVICE=jpeg -o $1.jpg -sPAPERSIZE=a4 $1 >/dev/null
