class packages::mozilla::python27 {
    case $operatingsystem{
        CentOS,RedHat: {
            package {
                "mozilla-python27":
                    ensure => latest;
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
