class hugo ($basedir = '/srv/www') {
  require golang
  user {'hugo':
    home => '/var/empty',
    shell => '/sbin/nologin',
    tag => 'web',
  }
  group {'hugo':}
  
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

  upstart::service {'hugo':
    ensure => running,
    desc => "Static site generator auto-generation",
    user => 'hugo',
    group => 'web',
    umask => '002',
    respawn => true,
    directory => '/srv/hugo',
    command => '/usr/local/bin/hugo --watch',
    require => [
      Golang::Get['github.com/spf13/hugo'],
      User[hugo],
      Group[web],
      File['/web/static','/web/layouts','/web/content','/web/public'],
    ]
  }
}
