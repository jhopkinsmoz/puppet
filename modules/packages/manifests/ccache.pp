class packages::ccache {
    case $operatingsystem {
        CentOS,RedHat: {
            package {
                "ccache":
                    ensure => latest;
            }
        }

        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
