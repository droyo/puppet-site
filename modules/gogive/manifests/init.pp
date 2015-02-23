class gogive(
  $port,
  $paths = {},
) {
  include golang
  
  file {'/etc/gogive.conf':
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('gogive/gogive.conf.erb'),
  }

  golang::get{'github.com/droyo/gogive':}
  systemd::service{'gogive':
    ensure  => running,
    enable  => true,
    user    => 'nobody',
    group   => 'nobody',
    command => "${golang::path}/bin/gogive -a :${port} /etc/gogive.conf",
    require => Golang::Get['github.com/droyo/gogive'],
  }
}
