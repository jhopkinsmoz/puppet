class dirs::builds::ccache {
    include dirs::builds

    file {
        "/builds/ccache":
            ensure => directory,
            owner => "$config::builder_username",
            group => "$config::builder_username",
            mode => 0755;
    }

    exec {
        "ccache-maxsize":
            require => [File["/builds/ccache"], Package["ccache"]],
            command => "/usr/bin/ccache -M10G",
            environment => [
                "CCACHE_DIR=/builds/ccache",
                ],
            user => "$config::builder_username";
    }
}
