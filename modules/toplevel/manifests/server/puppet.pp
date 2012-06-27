# toplevel class for running a puppet master
class toplevel::server::puppet {
    include toplevel::server
    include nrpe::check::ntp_time
    include nrpe::check::ganglia
    include puppet

    package {
        "httpd":
            ensure => installed;
        "mod_ssl":
            ensure => installed;
        "mod_passenger":
            require => Package["puppet-server"],
            ensure => installed;
        "puppet-server":
            require => Package["puppet"],
            ensure => $puppet::puppet_version;
        "createrepo":
            ensure => installed;
        "mercurial":
            ensure => installed;
        "git":
            ensure => installed;
    }

    file {
        "/etc/puppet/fileserver.conf":
            mode => 0644,
            owner => root,
            group => root,
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/fileserver.conf";
        "/etc/puppet/autosign.conf":
            mode => 0644,
            owner => root,
            group => root,
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/autosign.conf";
        # TODO: add a crontab entry for the following file
        "/etc/puppet/update.sh":
            mode => 0755,
            owner => root,
            group => root,
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/update.sh";
        "/etc/httpd/conf.d/yum_mirrors.conf":
            require => Package["httpd"],
            source => "puppet:///modules/toplevel/server/puppet/yum_mirrors.conf";
        "/etc/httpd/conf.d/puppetmaster.conf":
            require => [Package["httpd"], Package["mod_ssl"], Package["mod_passenger"]],
            content => template("toplevel/server/puppet/mod_passenger.conf.erb");
        "/var/lib/puppet/ssl/ca":
            ensure => directory,
            owner => puppet,
            group => puppet,
            mode => 0750;
        "/etc/sysconfig/iptables":
            source => "puppet:///modules/toplevel/server/puppet/iptables";
        ["/etc/puppet/rack", "/etc/puppet/rack/public"]:
            ensure => directory,
            owner  => puppet,
            group  => puppet;
        "/etc/puppet/rack/config.ru":
            owner  => puppet,
            group  => puppet,
            source => "puppet:///modules/toplevel/server/puppet/config.ru";

    }

    service {
        # TODO: this isn't getting refreshed
        "iptables":
            require => [
                File["/etc/sysconfig/iptables"],
            ],
            subscribe => File["/etc/sysconfig/iptables"],
            enable => true;
        "puppetmaster":
            require => [
                Package["puppet-server"],
                File["/etc/puppet/puppet.conf"],
                File["/etc/puppet/fileserver.conf"],
                File["/var/lib/puppet/ssl/ca"],
            ],
            ensure => stopped,
            enable => false;
        "httpd":
            require => [
                Package["httpd"], Package['mod_ssl'], Package['mod_passenger'],
                File["/etc/httpd/conf.d/yum_mirrors.conf"],
                File['/etc/httpd/conf.d/puppetmaster.conf']
            ],
            subscribe => [
                File["/etc/httpd/conf.d/yum_mirrors.conf"],
                File['/etc/httpd/conf.d/puppetmaster.conf']
            ],
            ensure => running,
            enable => true;
    }
}
