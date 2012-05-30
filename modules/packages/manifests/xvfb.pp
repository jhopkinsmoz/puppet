class packages::xvfb {
    case $operatingsystem {
        CentOS,RedHat: {
            package {
                "xorg-x11-server-Xvfb":
                    ensure => latest;
                # For RANDR extension in xvfb
                "libXrandr":
                    ensure => latest;
            }
        }

        default: {
            fail("cannot install on $operatingsystem")
        }
    }
}
