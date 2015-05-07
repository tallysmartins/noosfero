#!/bin/bash

echo 'I: starting integration backup...'

echo 'I: Creating /tmp/backups/ on integration'
mkdir -p /tmp/backups/

# Colab Backup
echo 'I: dumping colab data'
colab-admin dumpdata > /tmp/backups/colab_dump.json

# GitLab Backup
cd /usr/lib/gitlab
echo 'I: creating gitlab backup'
sudo -u git bundle exec rake gitlab:backup:create RAILS_ENV=production > /dev/null
# TODO fix regular expression
mv /var/lib/gitlab/backups/*_gitlab_backup.tar /tmp/backups

echo 'I: creating gitlab shell ssh backup'
tar -czf /tmp/backups/gitlab_shell_ssh.tar.gz /var/lib/gitlab-shell/.ssh/ 2> /dev/null

# Mailman Backup
cd /var/lib/mailman
echo 'I: creating mailman backups'
tar -czf /tmp/backups/mailman_backup.tar.gz lists/ data/ archives/

echo 'I: integration backup done.'

