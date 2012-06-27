node /bld-centos6-hp-\d+.build.scl1.mozilla.com/ {
    include toplevel::slave::build::mock
}

node "relabs07.build.mtv1.mozilla.com" {
    include toplevel::slave::build
}

node "relabs08.build.mtv1.mozilla.com" {
    include toplevel::slave::build::mock
}

node "relabs-buildbot-master.build.mtv1.mozilla.com" {
    include toplevel::server
}

node "relabs-slave.build.mtv1.mozilla.com" {
    include toplevel::slave::test
}

node /.*\.build\.aws-us-west-1\.mozilla\.com/ {
    # Make sure we get our /etc/hosts set up
    class {
        "network::aws": stage => packagesetup,
    }
    include toplevel::slave::build::mock
}

node /^puppetmaster-\d+/ {
    include toplevel::server::puppetmaster
}

node "linux-foopy-test.build.mtv1.mozilla.com" {

}
