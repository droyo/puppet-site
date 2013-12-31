class hugo ($baseurl = "https://${::fqdn}") {
  require golang
  user {'hugo':
    home => '/var/empty',
    shell => '/sbin/nologin',
    tag => 'web',
  }
  group {'hugo':}
  
  file {['/web/content','/web/public']:
    ensure => directory,
    owner => 'root',
    group => 'web',
    mode => '2775',
  }
  
  file {'/web/static':
    ensure => directory,
    owner => 'root',
    group => 'web',
    mode => '2775',
    recurse => true,
    source => 'puppet:///modules/hugo/static',
  }
  
  file {'/web/layouts':
    ensure => directory,
    owner => 'root',
    group => 'web',
    mode => '2775',
    recurse => true,
    source => 'puppet:///modules/hugo/layouts',
  }
  
  golang::get{'github.com/spf13/hugo':}
  
  file {'/web/config.toml':
    content => template('hugo/hugo.toml.erb'),
    notify => Service['hugo'],
  }
  upstart::service {'hugo':
    ensure => running,
    desc => "Static site generator auto-generation",
    user => 'hugo',
    group => 'web',
    umask => '002',
    respawn => true,
    command => '/usr/local/bin/hugo -w -s /web --config=/web/config.toml',
    require => [
      Golang::Get['github.com/spf13/hugo'],
      User[hugo],
      Group[web],
      File['/web/static','/web/layouts','/web/content','/web/public'],
    ]
  }
}
