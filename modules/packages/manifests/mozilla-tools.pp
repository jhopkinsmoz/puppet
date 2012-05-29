# This is a class that describes a fairly generic set of mozilla
# tools packages

class packages::mozilla-tools {
    include dirs::tools

    case $operatingsystem{
        CentOS,RedHat: {
            # These are mozilla custom tools
            package {
                "mozilla-python27-mercurial":
                    ensure => latest,
                    require => Class['packages::python27'];
                "mozilla-python27-virtualenv":
                    ensure => latest,
                    require => Class['packages::python27'];
                "mozilla-git":
                    ensure => latest;
                "mock_mozilla":
                    ensure => latest;
                "xorg-x11-server-Xvfb":
                    ensure => latest;
                "libXrandr":
                    ensure => latest;
                "metacity":
                    ensure => latest;
                "supervisor":
                    ensure => latest;
                "ccache":
                    ensure => latest;
            }

            # These are upstream CentOS packages we want
            package {
                "mock": ensure => latest;
                "createrepo": ensure => latest;

            }

            file {
                "/etc/mock_mozilla/mozilla-f11-i386.cfg":
                    ensure => present,
                    source => "puppet:///modules/packages/mozilla-f11-i386.cfg";
                "/etc/mock_mozilla/mozilla-f16-i386.cfg":
                    ensure => present,
                    source => "puppet:///modules/packages/mozilla-f16-i386.cfg";
                "/etc/mock_mozilla/mozilla-centos6-i386.cfg":
                    ensure => present,
                    source => "puppet:///modules/packages/mozilla-centos6-i386.cfg";
                "/etc/mock_mozilla/mozilla-centos6-x86_64.cfg":
                    ensure => present,
                    source => "puppet:///modules/packages/mozilla-centos6-x86_64.cfg";
                "/etc/supervisord.conf":
                    require => Package["supervisor"],
                    ensure => present,
                    source => "puppet:///modules/packages/supervisord.conf";
		"/usr/local/bin/hg":
		    ensure => "/tools/python27-mercurial/bin/hg",
		    require => Package["mozilla-python27-virtualenv"];
            }

            service {
                "supervisord":
                    require => File["/etc/supervisord.conf"],
                    subscribe => File["/etc/supervisord.conf"],
                    enable => true,
                    ensure => running;
            }

            # The puppet group type can't do this it seems
            exec {
                "mock_mozilla-add":
                    require => [Package["mock_mozilla"],User["$config::builder_username"]],
                    command => "/usr/bin/gpasswd -a $config::builder_username mock_mozilla";
                "mock-add":
                    require => [Package["mock"],User["$config::builder_username"]],
                    command => "/usr/bin/gpasswd -a $config::builder_username mock";
            }
        }
        default: {
            fail("cannot install on $operatingsystem")
        }
    }

}
