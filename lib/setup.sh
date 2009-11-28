#!/bin/bash

ALREADY_SETUP=0

WP_TAR_DIR=`pwd`"/wordpress_tars"
WP_MY_DIR=$WP_TAR_DIR"/working_code"
WP_LIVE_DIR=`pwd`"/wordpress_live"

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
LATEST_WP_TAR=`find . -name wordpress-\*.tar.gz | tail -n 1`
LATEST_WP_TAR=$WP_TAR_DIR/$LATEST_WP_TAR
LATEST_WP_NUM=`../lib/wp_version_num.sh "$LATEST_WP_TAR"`

if [ -d $WP_MY_DIR ]; then
	cd $WP_MY_DIR
	ALREADY_SETUP=`git branch | grep 'live' | wc -l`
	if [ $ALREADY_SETUP -eq 1 ]; then
		exit 0
	else
		echo "Something's not right. Please delete the working_code directory and try running upgrade.sh again."
		exit 1
	fi
else
	mkdir $WP_MY_DIR
fi

echo "Setting up git_wordpress_updated..."

../lib/wp_untar.sh $LATEST_WP_TAR $WP_MY_DIR

cd $WP_MY_DIR
git status
if [ "$?" -eq "0" ]; then
	echo "Sorry, the working_code directory must not be under git control before this script is run."
	echo "Please delete the working_code/.git directory and run upgrade.sh again."
	exit 1
fi

git init
git add .
git commit -a -m "WordPress $LATEST_WP_NUM"

GIT_STATUS=`git status 2> /dev/null | tail -n1`
if [ "$GIT_STATUS" != "nothing to commit (working directory clean)" ]; then
	echo "There was an error committing WordPress to git."
	exit 1
fi

git checkout -b live

git clone --branch live $WP_MY_DIR $WP_LIVE_DIR

# I'm adding a "warning" branch to try and keep inexperienced users from deleting
# things they shouldn't.
git checkout -b warning
find . -d 1 ! -name '.git*' -exec rm -rf {} \;
echo "WARNING: Please do NOT delete this 'working_code' directory. Doing so will seriously break git_wordpress_updated." > WARNING.TXT
git add .
git commit -a -m "Adding a warning to the working_copy"

echo ""
echo "Your WordPress installation is ready for modification."
echo "Make whatever changes you want in the wordpress_live directory."
echo "You may want to follow the WordPress installation instructions: http://codex.wordpress.org/Installing_WordPress"
echo ""
echo "When a new version of WordPress is released, download the tar.gz file into the wordpress_tars directory and run upgrade.sh."
echo ""
exit 2

