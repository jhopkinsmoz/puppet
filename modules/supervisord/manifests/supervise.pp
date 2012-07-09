define supervisord::supervise($command, $user, $autostart=true, $autorestart=true) {
    include supervisord::base

    file {
        "/etc/supervisord.conf.d/$name":
            content => template("supervisord/snippet.erb"),
            notify => Exec["supervisord_make_config"];
    }

    service {
        "supervisord::$name":
            enable => true,
            ensure => running,
            status => "/usr/bin/supervisorctl status $name",
            restart => "/usr/bin/supervisorctl restart $name",
            start => "/usr/bin/supervisorctl start $name",
            start => "/usr/bin/supervisorctl stop $name",
    }
}
