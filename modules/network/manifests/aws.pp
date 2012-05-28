class network::aws {
    host {
        "repos":
            ensure => present,
            ip => $serverip;
        "puppet":
            ensure => present,
            ip => $serverip;
        "runtime-binaries.pvt.build.mozilla.org":
            ensure => present,
            ip => $serverip;
        "hg.mozilla.org":
            ensure => present,
            ip => "10.22.74.30";
    }
}
