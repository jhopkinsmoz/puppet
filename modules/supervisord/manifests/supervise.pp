define supervisord::supervise($command, $user, $autostart=true, $autorestart=true, $configtest_command="") {
    include supervisord::base

    file {
        "/etc/supervisord.conf.d/$name":
            content => template("supervisord/snippet.erb"),
            notify => Exec["supervisord_make_config"];
        "/etc/init.d/supervisord-$name":
            content => template("supervisord/service.erb"),
            mode => 0755;
    }

    service {
        "supervisord-$name":
            require => File["/etc/init.d/supervisord-$name"],
            enable => $autostart,
            ensure => $autorestart ? {
                true => "running",
                default => false,
            };
    }
}
