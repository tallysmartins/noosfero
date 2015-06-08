#!/bin/bash

echo 'Starting restore on integration...'
# Colab Restore
echo 'restoring colab...'
psql -U colab -h database colab < /tmp/backups/colab.dump 1> /dev/null 2> /dev/null
colab-admin migrate > /dev/null
echo 'done.'

# Gitlab Restore
echo 'cleaning gitlab backups directory'
sudo rm -rf /var/lib/gitlab/backups/*
echo 'restoring gitlab...'
#TODO: fix wildcard
mv /tmp/backups/*_gitlab_backup.tar /var/lib/gitlab/backups/
cd /usr/lib/gitlab
sudo -u git bundle exec rake gitlab:backup:restore RAILS_ENV=production force=yes 1> /dev/null 2>/dev/null
sudo rm -rf /var/lib/gitlab/backups/*
echo 'done.'

# Mailman Restore
echo 'restoring mailman...'
sudo mv /tmp/backups/mailman_backup.tar.gz /var/lib/mailman/
cd /var/lib/mailman
sudo tar -xzf mailman_backup.tar.gz
sudo rm mailman_backup.tar.gz
cd /usr/lib/mailman/bin
for list in `sudo ls /var/lib/mailman/lists`; do sudo ./withlist -l -r fix_url $list -u $SPB_URL 1> /dev/null 2> /dev/null; done

echo 'done.'
