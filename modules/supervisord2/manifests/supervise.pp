define supervisord2::supervise($command, $user, $autostart=true, $autorestart=true) {
    include supervisord2::base

    file {
        "/etc/supervisord.conf.d/$name":
            content => template("supervisord2/snippet.erb"),
            before => Exec["supervisord_make_config"],
            notify => Exec["supervisord_make_config"];
    }
}
