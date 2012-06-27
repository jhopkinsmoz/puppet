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
        "puppet-server":
            require => Package["puppet"],
            ensure => $puppet::puppet_version;
        "createrepo":
            ensure => installed;
        "mercurial":
            ensure => installed;
        "git":
            ensure => installed;
        "rubygem-mongrel":
            ensure => installed;
        "inotify-tools":
            ensure => installed;
    }

    file {
        "/etc/puppet/fileserver.conf":
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/fileserver.conf";
        "/etc/puppet/autosign.conf":
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/autosign.conf";
        "/etc/httpd/conf.d/yum_mirrors.conf":
            require => Package["httpd"],
            source => "puppet:///modules/toplevel/server/puppet/yum_mirrors.conf";
        "/etc/httpd/conf.d/puppetmaster.conf":
            require => [Package["httpd"], Package["mod_ssl"]],
            content => template("toplevel/server/puppet/puppetmaster.conf.erb");
        "/var/lib/puppet/ssl/ca":
            ensure => directory,
            owner => puppet,
            group => puppet,
            mode => 0750;
        "/etc/sysconfig/iptables":
            source => "puppet:///modules/toplevel/server/puppet/iptables";
        "/etc/sysconfig/puppetmaster":
            source => "puppet:///modules/toplevel/server/puppet/puppetmaster.sysconfig";
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
                File["/etc/sysconfig/puppetmaster"],
                File["/var/lib/puppet/ssl/ca"],
            ],
            # TODO: Add config version script
            subscribe => [File["/etc/puppet/puppet.conf"], File["/etc/puppet/fileserver.conf"]],
            ensure => running,
            enable => true;
        "httpd":
            require => [Package["httpd"], File["/etc/httpd/conf.d/yum_mirrors.conf"]],
            subscribe => File["/etc/httpd/conf.d/yum_mirrors.conf"],
            ensure => running,
            enable => true;
    }
}
