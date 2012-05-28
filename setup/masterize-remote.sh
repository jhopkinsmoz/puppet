#!/bin/sh
set -e
set -x
host=$1
scp masterize.sh root@$host:
ssh root@$host 'mkdir -p /etc/puppet'
rsync -aP --delete --exclude repos ../ root@$host:/etc/puppet/production
rsync -aP --delete ../repos/yum/ root@$host:/var/www/html/repos/yum/
rsync -aP --delete ../repos/python/ root@$host:/var/www/html/python/
ssh root@$host 'chown -R root:root /var/www/html /etc/puppet/production'
ssh root@$host 'echo 0 > /selinux/enforce'
#ssh root@$host 'hostname puppet.releng.aws-us-west-1.mozilla.com'
#ssh root@$host 'bash masterize.sh'
