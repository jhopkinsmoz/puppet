define supervisord::supervise($command, $user, $autostart=true, $autorestart=true) {
    include supervisord::base

    file {
        "/etc/supervisord.conf.d/$name":
            content => template("supervisord/snippet.erb"),
            notify => Exec["supervisord_make_config"];
        "/etc/init.d/supervisord-$name":
            content => "#!/bin/sh",
            mode => 0755;
    }

    service {
        "supervisord-$name":
            require => File["/etc/init.d/supervisord-$name"],
            enable => true,
            ensure => running,
            status => "/usr/bin/supervisorctl status $name",
            restart => "/usr/bin/supervisorctl restart $name",
            start => "/usr/bin/supervisorctl start $name",
            stop => "/usr/bin/supervisorctl stop $name";
    }
}
