#!/bin/bash

WP_MY_DIR=`pwd`"/wordpress_my_install"
WP_TAR_DIR=`pwd`"/wordpress_tars"

if [ -d $WP_TAR_DIR ]; then
	touch $WP_TAR_DIR
else
	echo "Please download the tar.gz of WordPress that you currently use and put it in the following directory:"
	echo $WP_TAR_DIR
	echo ""
	echo "Once that's in place run upgrade.sh again."
	mkdir $WP_TAR_DIR
	exit 1
fi

cd $WP_TAR_DIR
LATEST_WP_TAR=`find . -name wordpress\*.tar.gz | tail -n 1`

if [ -d $WP_MY_DIR ]; then
	git status
	if [ "$?" -ne "0" ]; then
		echo "Something's not right. Please delete the wordpress_my_install directory and try running upgrade.sh again."
		exit 1
	fi
	exit 0
else
	mkdir $WP_MY_DIR
fi

LATEST_WP_TAR=$WP_TAR_DIR/$LATEST_WP_TAR

tar xzvf $LATEST_WP_TAR -C $WP_TAR_DIR
if [ "$?" -ne "0" ]; then
	echo "Error untaring "`basename $LATEST_WP_TAR`
	exit 1
fi

if [ -d $WP_TAR_DIR/wordpress ]; then
	cp -R $WP_TAR_DIR/wordpress/ $WP_MY_DIR/
else
	echo "Error untaring "`basename $LATEST_WP_TAR`" wordpress dir not found."
	exit 1
fi

cd $WP_MY_DIR
git status
if [ "$?" -eq "0" ]; then
	echo "Sorry, the wordpress_my_install directory must not be under git control before this script is run."
	echo "Please delete the wordpress_my_install/.git directory and run upgrade.sh again."
	exit 1
fi

git init
git add *
git commit -m "Initial Commit"

if [ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]; then
	exit 0
else
	
fi
