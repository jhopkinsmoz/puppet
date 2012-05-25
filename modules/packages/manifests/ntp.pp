class packages::ntp {
    case $operatingsystem {
        CentOS,RedHat: {
            package {
                "ntp":
                    ensure => latest;
            }
        }

        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
