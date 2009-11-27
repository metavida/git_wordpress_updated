#!/bin/bash

# Copyright 2009 Marcos Wright Kuhns - http://www.kuhnsfam.com
# Based on http://www.guyrutenberg.com/2008/05/07/wordpress-backup-script/
# (C) 2008 Guy Rutenberg - http://www.guyrutenberg.com
# This is a script that creates backups of blogs.

NO_ARGS=0
OPTERROR=65

while getopts ":u:p:h:" Option
do
  case $Option in
    u ) DB_USER=$OPTARG;;
    p ) DB_PASS=$OPTARG;;
    h ) DB_HOST=$OPTARG;;
    *     ) echo "Unimplemented option chosen.";;   # DEFAULT
  esac
done

shift $(($OPTIND - 1))

if [ $# -eq "$NO_ARGS" ]  # Script invoked with no command-line args?
then
  echo "Usage: `basename $0` -u username -p password [-h host] db_name"
  exit $OPTERROR
fi

DB_NAME=$1

BACKUP_DIR=`pwd`"/wordpress_db_backup"
BACKUP_FILE=$BACKUP_DIR/$DB_NAME.sql

if [ -d $BACKUP_DIR ]; then
	touch $BACKUP_DIR
else
	mkdir $BACKUP_DIR
fi

cd $BACKUP_DIR

git status
if [ "$?" -ne "0" ]; then
	git init
	git add *
	git commit -m "Initial Commit"
fi

echo "Backing up the database... "
# Deleting the old backup
if [ -f $BACKUP_FILE ]; then
	rm $BACKUP_FILE
fi

# Dumping the new backup
mysqldump --user=${DB_USER} --password=${DB_PASS} --host=${DB_HOST} ${DB_NAME} --skip-dump-date > $BACKUP_FILE
if [ "$?" -ne "0" ]; then
	echo -e "\nmysqldump failed!"
	git checkout .
	exit 1
fi

if [ `git diff | wc -l` -eq 0 ]; then
	# If there have been any changes to the DB, back them up
	git add *
	git commit -m "Backed up on $(date)"
	git gc --quiet
fi

echo "database backup complete"
