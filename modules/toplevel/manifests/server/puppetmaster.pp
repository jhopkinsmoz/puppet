# toplevel class for running a puppet master
class toplevel::server::puppetmaster {

    package {
        "mod_ssl":
            ensure => installed;
        "mod_passenger":
            ensure => installed;
    }

    file {
        "/etc/httpd/conf.d/mod_passenger.conf":
            require => [Package["mod_passenger"], Package["httpd"]],
            content => template("toplevel/server/puppet/mod_passenger.conf.erb");
        "/etc/httpd/ca_crl.pem":
            require => Package["httpd"],
            content => file("/var/lib/puppet/ssl/ca/ca_crl.pem");
        ["/var/lib/puppet/rack", "/var/lib/puppet/rack/public"]:
            ensure => directory,
            owner  => "puppet",
            group  => "puppet",
            require => Package["puppet-server"];
        "/var/lib/puppet/rack/config.ru":
            require => File["/var/lib/puppet/rack"],
            owner  => "puppet",
            group  => "puppet",
            source => "puppet:///modules/toplevel/server/puppet/config.ru";
    }

}
