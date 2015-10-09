#!/bin/bash

set -e

BKP_DIR=/usr/lib/noosfero/tmp/backup

cd /usr/lib/noosfero
RAILS_ENV=production sudo -u noosfero bundle exec rake backup
cd -
mv $BKP_DIR/`ls -tr $BKP_DIR | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}:[0-9]{2}\.tar\.gz' | tail -1` noosfero_backup.tar.gz

