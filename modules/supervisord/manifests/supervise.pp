define supervisord::supervise($command, $user, $autostart=true, $autorestart=true, $configtest_command="") {
    include supervisord::base

    file {
        "/etc/supervisord.conf.d/$name":
            content => template("supervisord/snippet.erb"),
            notify => Exec["supervisord_make_config"];
    }
}
