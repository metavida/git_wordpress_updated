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
BACKUP_DIR=$2

#no trailing slash

echo -n "dumping database... "
mysqldump --user=${DB_USER} --password=${DB_PASS} --host=${DB_HOST} ${DB_NAME} ${BACKUP_DIR}/${DB_NAME}-$(date +%Y%m%d).sql.bz2
if [ "$?" -ne "0" ]; then
	echo -e "\nmysqldump failed!"
	exit 1
fi
echo "done"
