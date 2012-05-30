# toplevel class for running a puppet master
class toplevel::server::puppet inherits toplevel::base {
    include nrpe::check::ntp_time
    include nrpe::check::ganglia
    include puppet

    package {
        "httpd":
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
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/fileserver.conf";
        "/etc/puppet/autosign.conf":
            require => Package["puppet-server"],
            source => "puppet:///modules/toplevel/server/puppet/autosign.conf";
        "/etc/httpd/conf.d/yum_mirrors.conf":
            require => Package["httpd"],
            source => "puppet:///modules/toplevel/server/puppet/yum_mirrors.conf";
        "/var/lib/puppet/ssl/ca":
            ensure => directory,
            owner => puppet,
            group => puppet,
            mode => 0750;
        "/etc/sysconfig/iptables":
            source => "puppet:///modules/toplevel/server/puppet/iptables";
        # TODO: move to another module
        # TODO: also, make this work
        ["/etc/sysconfig/selinux", "/etc/selinux/config"]:
            source => "puppet:///modules/toplevel/server/puppet/selinux";
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
