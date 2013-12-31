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
}
