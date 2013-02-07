class nginx {
    
    host {'self':
        ensure       => present,
    }
   
    package { "nginx":
        ensure => present,
    } 
    exec { 'apt-get update':
        command => '/usr/bin/apt-get update',
        before => Package["nginx"]
    }

    package { "git":
        ensure => present,
    }
    
    file { '/etc/nginx/sites-available/default':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/nginx/default',
        require => Package["nginx"],
    }
    
    file { "/etc/nginx/sites-enabled/default":
        notify => Service["nginx"],
        ensure => link,
        target => "/etc/nginx/sites-available/default",
        require => Package["nginx"],
    }
    
    service { "nginx":
      ensure => running,
      require => Package["nginx"],
    }
    
}
    
include nginx