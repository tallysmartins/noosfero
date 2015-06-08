#!/bin/bash
cd /usr/lib/noosfero
RAILS_ENV=production sudo -u noosfero bundle exec rake backup
cd -
# TODO fix regular expression
mv /usr/lib/noosfero/tmp/backup/*.tar.gz noosfero_backup.tar.gz
