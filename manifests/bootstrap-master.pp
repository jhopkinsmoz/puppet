# manifest for getting a puppet master up and running
# this can be run directly via puppet apply bootstrap-master.pp
stage { 'prereqs': before => Stage['main'] }

class prereqs {
    package {
        "mercurial":
            required => installed;
    }

    exec {
        "clone-manifests":
            require => Package["puppet-server", "mercurial"],
            #command => "/usr/bin/hg clone http://hg.mozilla.org/build/puppet /etc/puppet/production",
            # For testing, copy local files
            command => "/bin/false",
            creates => "/etc/puppet/production";
    }
}

class {
    'prereqs': stage => prereqs;
}

include toplevel::server::puppet
