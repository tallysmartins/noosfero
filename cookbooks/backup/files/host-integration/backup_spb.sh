#!/bin/bash
#colab-admin dumpdata > /tmp/backups/colab_dump.json
pg_dump -h database -U colab colab > colab.dump
# GitLab Backup
cd /usr/lib/gitlab
sudo -u git bundle exec rake gitlab:backup:create RAILS_ENV=production
cd -
# TODO fix regular expression
mv /var/lib/gitlab/backups/*_gitlab_backup.tar .

tar -czf gitlab_shell_ssh.tar.gz /var/lib/gitlab-shell/.ssh/

# Mailman Backup
cd /var/lib/mailman
tar -cpzf mailman_backup.tar.gz lists/ data/ archives/
cd -
mv /var/lib/mailman/mailman_backup.tar.gz .

