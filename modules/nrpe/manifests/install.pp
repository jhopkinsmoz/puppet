class nrpe::install {
    case $operatingsystem {
        CentOS,RedHat: {
            package {
                "nrpe":
                    ensure => latest;
                "nagios-plugins-nrpe":
                    ensure => latest;
                "nagios-plugins-all":
                    ensure => latest;
            }
        }
    }
}
