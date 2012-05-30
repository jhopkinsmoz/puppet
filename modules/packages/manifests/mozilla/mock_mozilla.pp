class packages::mozilla::mock_mozilla {
    case $operatingsystem{
        CentOS,RedHat: {
            package {
                "mock_mozilla":
                    ensure => latest;
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
