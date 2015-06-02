#!/bin/bash

echo 'Starting restore on social...'
#Noosfero restore
echo 'restoring Noosfero...'
cd /usr/lib/noosfero
yes y | RAILS_ENV=production sudo -u noosfero bundle exec rake restore BACKUP=/tmp/backups/noosfero_backup.tar.gz 1> /dev/null 2>/dev/null
echo 'done.'
