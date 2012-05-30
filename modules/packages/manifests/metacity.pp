class packages::metacity {
    case $operatingsystem {
        CentOS,RedHat: {
            package {
                "metacity":
                    ensure => latest;
            }
        }

        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
