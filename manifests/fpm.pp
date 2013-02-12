stage { 'first': before => Stage['main'] }

class {
    'update': stage => 'first'
}

class update {
    exec { "apt-get update":
        command => "/usr/bin/apt-get update",
        onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'"
    }
}

class fpm {
    include nodejs
    
    $php = ["php5-fpm", "php5-cli", "php5-dev", "php5-gd", "php5-curl", "php-pear", "php-apc", "php5-mcrypt", "php5-xdebug", "php5-sqlite", "php5-imagick"]
    $imagemagicklib = ["imagemagick","libmagickwand-dev","libmagickcore-dev"]

    package { $imagemagicklib:
        ensure => present,
    }

    apt::ppa { "ppa:ondrej/php5":
        before => Package[$php],
    }

    package { "git":
        ensure => present,
    }

    exec { 'gem update --system':
        command => '/opt/vagrant_ruby/bin/gem update --system'
    }

    exec { 'gem install compass':
        command => '/opt/vagrant_ruby/bin/gem install compass',
        require => Exec['gem update --system']
    }

    package { "build-essential":
        ensure => present,
    }
    
    package { $php:
        notify => Service['php5-fpm'],
        ensure => latest,
    }

    package { 'less':
      ensure   => latest,
      provider => 'npm',
      require => Package['npm']
    }
    
    exec { 'pecl install mongo':
        notify => Service["php5-fpm"],
        command => '/usr/bin/pecl install --force mongo',
        logoutput => "on_failure",
        require => [Package["build-essential"], Package[$php]],
        before => [File['/etc/php5/cli/php.ini'], File['/etc/php5/fpm/php.ini'], File['/etc/php5/fpm/php-fpm.conf'], File['/etc/php5/fpm/pool.d/cloudruge.conf']],
        unless => "/usr/bin/php -m | grep mongo",
    }
    
    exec { 'pear config-set auto_discover 1':
        command => '/usr/bin/pear config-set auto_discover 1',
        before => Exec['pear install pear.phpunit.de/PHPUnit'],
        require => Package[$php],
        unless => "/bin/ls -l /usr/bin/ | grep phpunit",
    }
    
    exec { 'pear install pear.phpunit.de/PHPUnit':
        notify => Service["php5-fpm"],
        command => '/usr/bin/pear install --force pear.phpunit.de/PHPUnit',
        before => [File['/etc/php5/cli/php.ini'], File['/etc/php5/fpm/php.ini'], File['/etc/php5/fpm/php-fpm.conf'], File['/etc/php5/fpm/pool.d/cloudruge.conf']],
        unless => "/bin/ls -l /usr/bin/ | grep phpunit",
    }
    
    file { '/etc/php5/cli/php.ini':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/cli/php.ini',
        require => Package[$php],
    }
    
    file { '/etc/php5/fpm/php.ini':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/php.ini',
        require => Package[$php],
    }
    
    file { '/etc/php5/fpm/php-fpm.conf':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/php-fpm.conf',
        require => Package[$php],
    }
    
    file { '/etc/php5/fpm/pool.d/cloudruge.conf':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/pool.d/cloudruge.conf',
        require => Package[$php],
    }
    
    service { "php5-fpm":
      ensure => running,
      require => Package["php5-fpm"],
    }
    
}

include fpm