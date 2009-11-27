#!/bin/bash

ALREADY_SETUP="1"

WP_DIR=`pwd`"/wordpress_install"

if [ -d $WP_DIR ]; then
	exit 0
else
	echo "Please download the version of WordPress that you currently use and put it in the following directory:"
	echo $WP_DIR
	echo ""
	echo "Once that's in place run upgrade.sh again"
	mkdir $WP_DIR
fi
