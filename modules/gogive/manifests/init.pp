class gogive(
  $port,
  $addr = '',
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
  if $::osfamily == 'Debian' and versioncmp($::operatingsystemrelease, 8) < 0 {
    upstart::service{'gogive':
      ensure  => running,
      content => template('gogive/gogive.upstart.erb'),
      require => Golang::Get['github.com/droyo/gogive'],
    }
  } else {
    systemd::service{'gogive':
      ensure  => running,
      enable  => true,
      user    => 'daemon',
      group   => 'daemon',
      command => "/usr/local/bin/gogive -a ${addr}:${port} /etc/gogive.conf",
      require => Golang::Get['github.com/droyo/gogive'],
    }
  }
}
