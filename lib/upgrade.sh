#!/bin/bash

WP_TAR_DIR=`pwd`"/wordpress_tars"
WP_MY_DIR=$WP_TAR_DIR"/working_code"

cd $LIVE_WORDPRESS_DIR
git checkout live
if [[ `git diff | wc -l` -ne 0 ]]; then
	git add .
	git commit -a -m "Automatic commit by git_wordpress_updated."
fi

cd $WP_TAR_DIR
LATEST_WP_TAR=`find . -name wordpress-\*.tar.gz | tail -n 1`
LATEST_WP_NUM=`../lib/wp_version_num.sh "$LATEST_WP_TAR"`

cd $WP_MY_DIR
git checkout live
GIT_STATUS=`git status 2> /dev/null | tail -n1`
if [[ "$GIT_STATUS" != "nothing to commit (working directory clean)" ]]; then
	git checkout warning
	echo "It looks like someone has been manually making changes to the working_code."
	echo "This can cause some unexpected behavior and is strongly discouraged."
	echo "Please commit all changes to working_code:live and make sure they're applied to wordpress_live:live."
	exit 1
fi
git pull $LIVE_WORDPRESS_DIR live

git checkout master
if [[ `git log | grep -B 4 "WordPress $LATEST_WP_NUM" | wc -l` -ne 0 ]]; then
	git checkout warning
	echo "It looks like WordPress $LATEST_WP_TAR has already been installed."
	exit 1
fi

cd $WP_TAR_DIR
../lib/wp_untar.sh $LATEST_WP_TAR $WP_MY_DIR
cd $WP_MY_DIR

git add .
git commit -a -m "WordPress $LATEST_WP_NUM"

git checkout live

# Try to rebase
git rebase master
if [[ "$?" -ne "0" ]]; then
	git checkout warning
	echo ""
	echo "There was a conflict when applying the latest changes to WordPress."
	echo "At this point you may want to bring a developer into the mix."
	echo ""
	echo "You can review the list of files with conflicts by visiting the working_code directory and running the 'git status' command."
	echo ""
	exit 1
fi

git checkout warning

cd $LIVE_WORDPRESS_DIR
git pull $WP_MY_DIR live

echo ""
echo "The changes from WordPress $LATEST_WP_NUM have been successfully applied."
echo "There's only one step left in your upgrade process:"
echo " 1) Visit your blog's upgrade page & follow the instructions, e.g. http://example.com/wordpress/wp-admin/upgrade.php"
