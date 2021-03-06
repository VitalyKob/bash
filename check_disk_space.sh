#!/bin/sh
# set -x
# Shell script to monitor or watch the disk space
# It will send an email to $ADMIN, if the (free available) percentage of space is >= 90%.
# -------------------------------------------------------------------------
# Set admin email so that you can get email.
ADMIN=""
# set alert level 90% is default
ALERT=80
# Exclude list of unwanted monitoring, if several partions then use "|" to separate the partitions.
# An example: EXCLUDE_LIST="/opt/OpenAMPlugin"
EXCLUDE_LIST=""
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
function main_prog() {
while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep -ge $ALERT ] ; then
     echo "Running out of space $partition ($usep%) on server $(hostname), $(date)"
    # echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date)" | \
    # mail -s "Alert: Almost out of disk space $usep%" $ADMIN
    exit 1
  fi
done
}

if [ "$EXCLUDE_LIST" != "" ] ; then
  df -HP | grep -vE "^Filesystem|tmpfs|cdrom|mnt|${EXCLUDE_LIST}" | awk '{print $5 " " $6}' | main_prog
else
  df -HP | grep -vE "^Filesystem|tmpfs|cdrom|mnt" | awk '{print $5 " " $6}' | main_prog
fi
