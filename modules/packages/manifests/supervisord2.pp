class packages::supervisord2 {
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
