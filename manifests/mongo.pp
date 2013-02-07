class mongo {

    package { "mongodb-10gen":
        ensure => present,
        require => Exec["apt-key mongokey"]
    }

    # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
    exec { 'apt-key mongokey':
        command => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10',
        before => File["/etc/apt/sources.list.d/10gen.list"]
    }

    exec { 'apt-get update':
        command => '/usr/bin/apt-get update',
        before => Package["mongodb-10gen"],
        require => File["/etc/apt/sources.list.d/10gen.list"]
    }

    service { "mongodb":
        ensure => running,
        require => Package["mongodb-10gen"]
    }

    file { '/etc/apt/sources.list.d/10gen.list':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/apt/10gen.list'
    }
}
    
include mongo