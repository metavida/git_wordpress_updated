#!/bin/bash

LATEST_WP_TAR=$1
WP_TAR_DIR=`dirname $LATEST_WP_TAR`
WP_MY_DIR=$2

tar xzvf $LATEST_WP_TAR -C $WP_TAR_DIR
if [[ "$?" -ne "0" ]]; then
	echo "Error untaring "`basename $LATEST_WP_TAR`
	exit 1
fi

if [[ -d $WP_TAR_DIR/wordpress ]]; then
	find $WP_MY_DIR -d 1 ! -name '.git*' -exec rm -rf {} \;
	mv $WP_TAR_DIR/wordpress/* $WP_MY_DIR
	rm -rf $WP_TAR_DIR/wordpress
else
	echo "Error untaring "`basename $LATEST_WP_TAR`" wordpress dir not found."
	exit 1
fi
