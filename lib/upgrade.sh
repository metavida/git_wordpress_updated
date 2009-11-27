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
	git add .
	git commit -m "Automatic commit by git_wordpress_updated."
fi 

if [ `git log | grep -B 4 'WordPress $LATEST_WP_NUM' | wc -l` -ne 0 ]; then
	echo "It looks like WordPress $LATEST_WP_TAR has already been installed."
	exit 1
fi

git checkout master
../lib/wp_untar.sh $LATEST_WP_TAR $WP_MY_DIR

git add .
git commit -m "WordPress $LATEST_WP_NUM"

git checkout mine

# Try to rebase
git rebase master
if [ "$?" -eq "0" ]; then
	echo ""
	echo "There was a conflict when applying the latest changes to WordPress."
	echo "At this point you may want to bring a developer into the mix."
	echo ""
	echo "You can review the list of files with conflicts by visiting the wordpress_my_install directory and running the 'git status' command."
	echo ""
	exit 1
fi

echo ""
echo "The changes from WordPress $LATEST_WP_NUM have been successfully applied."
echo "There are two steps left in your upgrade process:"
echo " 1) Copy the contents of the wordpress_my_install over top of your current, live WordPress blog."
echo " 2) Visit your blog's upgrade page & follow the instructions, e.g. http://example.com/wordpress/wp-admin/upgrade.php"
