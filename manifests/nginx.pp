class nginx {
    
    host {'self':
        ensure       => present,
        name         => $fqdn,
        host_aliases => ['puppet', $hostname],
        ip           => $ipaddress,
    }
   
    package { "nginx":
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
    