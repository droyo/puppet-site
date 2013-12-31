class gogive(
  $port,
  $paths
) {
  require golang
  File {
    owner => 'root',
    group => 'root',
    mode => '0644',
  }
  
  golang::get{'github.com/droyo/gogive':}
  file {'/etc/gogive.conf':
    content => template('gogive/gogive.conf.erb'),
  }
  upstart::service{'gogive':
    ensure => running,
    content => template('gogive/gogive.upstart.erb'),
    require => Golang::Get['github.com/droyo/gogive'],
  }
}
