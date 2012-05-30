class packages::mock {
    case $operatingsystem{
        CentOS,RedHat: {
            package {
                "mock":
                    ensure => latest;
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
