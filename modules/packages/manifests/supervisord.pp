class packages::supervisord {
    case $operatingsystem {
        CentOS,RedHat: {
            package {
                "supervisor":
                    ensure => latest;
            }
        }

        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
