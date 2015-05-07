#!/bin/bash

echo 'I: starting social backup...'

echo 'I: Creating /tmp/backups/ on social'
mkdir -p /tmp/backups/

#Noosfero backup
cd /usr/lib/noosfero
echo 'I: creating Noosfero backup'
RAILS_ENV=production sudo -u noosfero bundle exec rake backup 2> /dev/null 1> /dev/null
# TODO fix regular expression
mv tmp/backup/*.tar.gz /tmp/backups/noosfero_backup.tar.gz

echo 'I: social backup done.'
