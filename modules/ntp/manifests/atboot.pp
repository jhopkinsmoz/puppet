class ntp::atboot {
    include packages::ntp

    case $operatingsystem {
        CentOS,RedHat: {
            service {
                "ntpdate": 
                    enable => true,
                    hasstatus => false;
            }
        }

        default: {
            fail("cannot instantiate on $operatingsystem")
        }
    }
}
