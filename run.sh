#!/bin/bash

# Copyright 2009 Marcos Wright Kuhns - http://www.guyrutenberg.com
#
# Backup 
# (C) 2008 Guy Rutenberg - http://www.guyrutenberg.com
# This is a script that creates backups of blogs.

DB_NAME=wp_db
DB_USER=wp_user
DB_PASS=wp_pass
DB_HOST=localhost

#echo "begin setup"
./lib/setup.sh
SETUP_STATUS=$?
if [ "$SETUP_STATUS" -eq "1" ]; then
	echo ""
	echo "Error setting up git_wordpress_updated."
	exit 1
elif [ "$SETUP_STATUS" -eq "2" ]; then
	# This was the first time this has been set up.
	exit 0
fi

#echo "begin database backup"
./lib/backup.sh -u $DB_USER -p $DB_PASS -h $DB_HOST $DB_NAME
if [ "$?" -ne "0" ]; then
	echo ""
	echo "Error backing up your WordPress Database."
	exit 1
fi

#echo "begin wordpress update"
./lib/upgrade.sh
if [ "$?" -ne "0" ]; then
	echo ""
	echo "Error upgrading to the newest version of WordPress."
	exit 1
fi

#
#WP_CLEAN_DIR=~/wordpress
#WP_CLEAN_DIR
#
##no trailing slash
#BLOG_DIR=/home/guyru/guyrutenberg.com
#BACKUP_DIR=/home/guyru/backups
#
#echo -n "dumping database... "
#mysqldump --user=${DB_USER} --password=${DB_PASS} --host=${DB_HOST} ${DB_NAME} \
# | bzip2 -c > ${BACKUP_DIR}/${DB_NAME}-$(date +%Y%m%d).sql.bz2
#if [ "$?" -ne "0" ]; then
#	echo -e "\nmysqldump failed!"
#	exit 1
#fi
#echo "done"
