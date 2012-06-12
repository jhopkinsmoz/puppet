class packages::mozilla::py27_mercurial {
    include packages::mozilla::python27
    case $operatingsystem{
        CentOS: {
            package {
                "mozilla-python27-mercurial":
                    ensure => latest,
                    require => Class['packages::mozilla::python27'];
            }
            file {
                "/usr/local/bin/hg":
                    ensure => "/tools/python27-mercurial/bin/hg",
                    require => Package["mozilla-python27-virtualenv"];
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
