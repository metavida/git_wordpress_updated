#!/bin/bash

WP_MY_DIR=`pwd`"/wordpress_my_install"
WP_TAR_DIR=`pwd`"/wordpress_tars"

cd $WP_TAR_DIR
LATEST_WP_TAR=`find . -name wordpress-\*.tar.gz | tail -n 1`
LATEST_WP_NUM=`../lib/wp_version_num.sh "$LATEST_WP_TAR"`

cd WP_MY_DIR
git checkout mine
if [ `git diff | wc -l` -eq 0 ]; then
	# If there have been any changes to the DB, back them up
	git add *
	git commit -m "Automatic commit by git_wordpress_updated."
	git gc --quiet
fi 

git checkout master
if [ `git log | grep 'Wordpress $LATEST_WP_NUM' | wc -l` -ne 0 ]; then
	
fi