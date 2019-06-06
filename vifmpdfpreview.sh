#!/bin/bash
time gs -sDEVICE=jpeg -o $1.jpg -sPAPERSIZE=a4 $1 >/dev/null
