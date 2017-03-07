class base {
  group {'web':
    ensure => present,
  }
  User <|tag == 'web'|> {
    groups +> 'web',
    require +> Group['web'],
  }
  file {'/web':
    ensure => directory,
    owner => 'root',
    group => 'web',
    mode => '2664',
  }
  augeas{'Disable root SSH login':
    context => '/files/etc/ssh/sshd_config',
    changes => 'set PermitRootLogin no',
  }
  package {'git':
    ensure => installed,
  }
  user {'droyo':
    managehome => true,
    tag => ['gophers', 'web'],
  }
}
