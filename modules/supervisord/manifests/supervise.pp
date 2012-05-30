define supervisord::supervise($command, $user, $autostart=true, $autorestart=true) {
    include supervisord::base

    file {
        "/etc/supervisord.conf.d/$name":
            content => template("supervisord/snippet.erb"),
            before => Exec["supervisord_make_config"],
            notify => Exec["supervisord_make_config"];
    }
}
