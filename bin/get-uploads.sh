#!/bin/sh
# src: https://gist.github.com/pixeline/0f9f922cffb5a6bba97a
# Requires lftp; brew install lftp

# FTP CONFIG
source sftp.cfg

# RUNTIME!
echo
echo "Starting download $REMOTE_UPLOADS from $HOST to $LOCAL_UPLOADS"
date

lftp -u "$USER","$PASSWORD" $HOST <<EOF
# the next 3 lines put you in ftpes mode. Uncomment if you are having trouble connecting.
# set ftp:ssl-force true
# set ftp:ssl-protect-data true
# set ssl:verify-certificate no
# transfer starts now...
mirror --use-pget-n=10 $REMOTE_UPLOADS $LOCAL_UPLOADS;
exit
EOF
echo
echo "Transfer finished"
date