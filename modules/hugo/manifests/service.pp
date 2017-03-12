class hugo::service {
  if $::osfamily == 'Debian' and versioncmp($::operatingsystemrelease, 8) < 0 {
    upstart::service {'hugo':
      ensure => running,
      user => 'hugo',
      group => 'web',
      umask => '002',
      directory => '/srv/hugo',
      respawn => true,
      command => '/usr/local/bin/hugo --watch',
      require => File['/srv/www', '/srv/hugo'],
    }
  } else {
    systemd::service {'hugo':
      ensure => running,
      description => "Static site generator auto-generation",
      user => 'hugo',
      group => 'web',
      umask => '002',
      directory => '/srv/hugo',
      command => '/usr/local/bin/hugo --watch',
      require => File['/srv/www', '/srv/hugo'],
    }
  }
}
