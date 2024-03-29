class packages::mozilla::py27_mercurial {
    include packages::mozilla::python27
    case $operatingsystem{
        CentOS: {
            package {
                "mozilla-python27-mercurial":
                    ensure => latest,
                    require => Class['packages::mozilla::python27'];
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
