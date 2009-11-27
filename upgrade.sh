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

echo "begin setup"
./lib/setup.sh
if [ "$?" -ne "0" ]; then
	echo "Error setting up git_wordpress_updated."
	exit 1
fi

echo "begin backup"
./lib/backup.sh -u $DB_USER -p $DB_PASS -h $DB_HOST $DB_NAME
if [ "$?" -ne "0" ]; then
	echo "Error backing up your wordpress DB."
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
