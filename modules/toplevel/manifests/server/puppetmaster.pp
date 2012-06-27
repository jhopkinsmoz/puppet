class toplevel::server::puppetmaster {

    file {
        "/var/lib/puppet/ssl/crl.pem":
        owner => puppet,
        group => puppet,
        mode => 0644,
        content => file("/var/lib/puppet/ssl/crl.pem");
    }
    exec {
        "/sbin/service httpd graceful":
            refreshonly => true,
            subscribe => File["/var/lib/puppet/ssl/crl.pem"];
    }
}
