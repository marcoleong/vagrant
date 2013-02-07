class mongo {

    package { "mongodb-10gen":
        ensure => present,
        require => [Apt::Key["mongo"], Apt::Source["10gen"]]
    }

    apt::key { "mongo":
        key => "7F0CEB10",
        key_server => "keyserver.ubuntu.com"
    }

    apt::source { "10gen" :
        location => "http://downloads-distro.mongodb.org/repo/ubuntu-upstart",
        release => "dist",
        repos => "10gen",
        include_src => false,
        require => Apt::Key["mongo"]
    }

    service { "mongodb":
        ensure => running,
        require => Package["mongodb-10gen"]
    }
}
    
include mongo