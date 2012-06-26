class puppet::config {
    include config

    case $fqdn {
        /^puppetca-\d+/: {
            file {
                "/etc/puppet/puppet.conf":
                    content => template("puppet/puppet.conf.erb");
            }
        }
        default: {
            file {
                "/etc/puppet/puppet.conf":
                    content => template("puppet/puppet.conf.erb");
            }
        }
}
