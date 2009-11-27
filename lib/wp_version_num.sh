#!/bin/bash

LATEST_WP_TAR=$1

if [ -f $LATEST_WP_TAR ]; then
	#echo $LATEST_WP_TAR
	LATEST_WP_NUM=`basename "$LATEST_WP_TAR"`
	#echo $LATEST_WP_NUM
	LATEST_WP_NUM=${LATEST_WP_NUM//\.\//}
	LATEST_WP_NUM=${LATEST_WP_NUM//wordpress-/}
	LATEST_WP_NUM=${LATEST_WP_NUM//.tar.gz/}
	echo $LATEST_WP_NUM
else
	echo 'x.x.x'
	exit 1
fi