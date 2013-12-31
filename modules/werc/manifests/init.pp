class werc (
) {
  require golang
  require plan9port
  
  user{'werc':
    home => '/var/empty',
    shell => '/sbin/nologin',
  }
  
  golang::get{'github.com/uriel/cgd':}
  
  upstart::service{'werc':
    ensure => running,
    content => template('werc/werc.upstart.erb'),
    require => [
      Golang::Get['github.com/uriel/cgd'],
      Exec['fetch werc'],
    ],
  }
  
  file {[
      '/web/pub',
      '/web/lib',
      '/web/sites',
  ]:
    owner => 'root',
    group => 'web',
    ensure => directory,
    require => Exec['fetch werc'],
  }
  
  File['/web/sites'] {
    mode => '2664',
  }
  
  File['/web/pub'] {
    recurse => true,
    mode => '0644',
    source => 'puppet:///modules/werc/pub',
  }
  
  File['/web/lib'] {
    recurse => true,
    mode => '0644',
    source => 'puppet:///modules/werc/lib',
  }
  
  exec {'fetch werc':
    command => 'hg clone http://hg.cat-v.org/werc/ .',
    cwd => '/web',
    creates => '/web/bin/werc.rc',
    require => Package['mercurial'],
    logoutput => on_failure,
  }
}
