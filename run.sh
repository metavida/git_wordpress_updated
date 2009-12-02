#!/bin/bash

# Copyright 2009 Marcos Wright Kuhns - http://www.guyrutenberg.com
#
# Backup 
# (C) 2008 Guy Rutenberg - http://www.guyrutenberg.com
# This is a script that creates backups of blogs.

config_file="config-sample.txt"
#tot=`wc -l $config_file`
#i=1
while read line; do
  name=`echo $line | sed "s/ *=.*//"`
  val=`echo $line | sed "s/[^=]*= *//"`
  
  case $name in
    DB_NAME           ) DB_NAME=$val;;
    DB_USER           ) DB_USER=$val;;
    DB_PASS           ) DB_PASS=$val;;
    DB_HOST           ) DB_HOST=$val;;
    LIVE_WORDPRESS_DIR) LIVE_WORDPRESS_DIR=$val;;
    #* ) echo "Unimplemented option chosen.";;
  esac
done < $config_file

if [[ -n $LIVE_WORDPRESS_DIR ]]; then
  LIVE_WORDPRESS_DIR=`pwd`"/wordpress_live"
fi

echo "begin setup"
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
if [ -n $DB_NAME ]; then
  ./lib/backup.sh -u $DB_USER -p $DB_PASS -h $DB_HOST $DB_NAME
  if [ "$?" -ne "0" ]; then
  	echo ""
  	echo "Error backing up your WordPress Database."
  	exit 1
  fi
else
  echo "If you want your WordPress DB to be backed up please set up config.txt correctly."
fi

#echo "begin wordpress update"
./lib/upgrade.sh
if [ "$?" -ne "0" ]; then
	echo ""
	echo "Error upgrading to the newest version of WordPress."
	exit 1
fi

#echo "deploy wordpress"
#./deploy.sh $LIVE_WORDPRESS_DIR
#if [ "$?" -ne "0" ]; then
#	echo ""
#	echo "Error deploying WordPress."
#	exit 1
#fi
