#!/bin/bash

echo 'Starting restore on integration...'
# Colab Restore
echo 'restoring colab...'
colab-admin loaddata /tmp/backups/colab_dump.json > /dev/null
echo 'done.'

# Gitlab Restore
echo 'cleaning gitlab backups directory'
sudo rm -rf /var/lib/gitlab/backups/*
echo 'restoring gitlab...'
#TODO: fix wildcard
mv /tmp/backups/*_gitlab_backup.tar /var/lib/gitlab/backups/
cd /usr/lib/gitlab
sudo -u git bundle exec rake gitlab:backup:restore RAILS_ENV=production force=yes 1> /dev/null 2>/dev/null
echo 'done.'

# Mailman Restore
echo 'restoring mailman...'
mv /tmp/backups/mailman_backup.tar.gz /var/lib/mailman/
cd /var/lib/mailman
tar -vxzf mailman_backup.tar.gz 1> /dev/null 2> /dev/null

echo 'done.'
