class packages::mozilla::python26 {
    case $operatingsystem{
        CentOS,RedHat: {
            package {
                "mozilla-python26":
                    ensure => latest;
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
