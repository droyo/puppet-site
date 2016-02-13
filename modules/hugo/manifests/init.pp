class hugo ($basedir = '/srv/www') {
  require golang
  include hugo::user
    
  file {['/srv/hugo', '/srv/www']:
    ensure => 'directory',
    owner  => 'root',
    group  => 'web',
    mode   => '2775',
  }
  file {'/srv/hugo/public':
    ensure => link,
    target => '/srv/www',
  }
  
  webhook::hook{'hugo':
    user      => 'hugo',
    group     => 'web',
    port      => '3950',
    directory => '/srv/hugo',
    command   => 'git pull origin master',
  }

  golang::get{'github.com/spf13/hugo':}
  if $::osfamily == 'Debian' {
    upstart::service {'hugo':
      ensure => running,
      user => 'hugo',
      group => 'web',
      umask => '002',
      directory => '/srv/hugo',
      respawn => true,
      command => 'hugo --watch',
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
