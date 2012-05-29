#!/bin/bash
set -e
set -x

echo "Setting up this host to be a puppet master"

MYHOSTNAME=`hostname -s`
MYFQDN=`hostname`
if [ "$MYHOSTNAME" == "$MYFQDN" ]; then
  echo "This host doesn't have a fqdn set. That will break ssl stuff. Please run \`hostname <fqdn>\` and run this script again."
  exit 1
fi
correctmatch=`grep $MYFQDN /etc/sysconfig/network || exit 0`
if [ -z "$correctmatch" ]; then
  echo "=== Fixing incorrect hostname in /etc/sysconfig/network"
  sed -i "s/^HOSTNAME=.*/HOSTNAME=$HOST/" /etc/sysconfig/network
  # sendmail will choke on the hostname change if we don\'t restart it.
  /sbin/service sendmail condrestart
fi

/bin/echo "=== Installing apache, setting up mirrors ==="
(/bin/rpm -q httpd  > /dev/null 2>&1 || /usr/bin/yum -y install httpd)
/bin/cp /etc/puppet/production/modules/toplevel/files/server/puppet/yum_mirrors.conf /etc/httpd/conf.d/yum_mirrors.conf
/etc/init.d/httpd restart

/bin/echo "=== Setting up yum repositories..."
#/bin/rm -f /etc/yum.repos.d/*
/bin/cp /etc/puppet/production/setup/yum-bootstrap.repo /etc/yum.repos.d
/bin/cp /etc/puppet/production/setup/hosts-bootstrap /etc/hosts

/bin/echo "=== Cleaning up yum ==="
/usr/bin/yum clean all

echo "=== Ensuring clock is set correctly..."
if ( `ps ax | grep -v grep | grep -q ntpd` ); then
    # Stop ntpd running. Puppet will start it back up
    /sbin/service ntpd stop
fi
/usr/sbin/ntpdate pool.ntp.org

/bin/echo "=== Installing puppet... ==="
# Make sure puppet-server isn't installed already.
# We can end up with file permission issues if we upgrade puppet-server between
# different rpm repos (e.g. from epel to puppetlabs)
(/bin/rpm -e puppet-server > /dev/null 2>&1 || exit 0)
(/bin/rpm -q puppet  > /dev/null 2>&1 || /usr/bin/yum -y install puppet)

/bin/echo "=== Applying toplevel::server::puppet..."
/bin/cp /etc/puppet/production/setup/puppet.conf /etc/puppet/puppet.conf

# TODO: This actually can return 0 if it fails to satisfy some dependencies
/usr/bin/puppet apply --modulepath /etc/puppet/production/modules --manifestdir /etc/puppet/production/manifests /etc/puppet/production/manifests/puppetmaster.pp || exit 1

#/bin/echo "=== Generating puppet CA..."
#/usr/sbin/puppetmasterd --ssldir=/var/lib/puppet/ssl-master
#sleep 1
#/usr/bin/killall puppetmasterd

/bin/echo "=== Fixing incorrect server name in /etc/puppet.conf"
/bin/sed -i "s/server = .*/server = $MYFQDN/" /etc/puppet/puppet.conf

exit 0
