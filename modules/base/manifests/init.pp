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
  package {['mercurial','git','bzr']:
    ensure => latest,
  }
  package {'w3m':
    ensure => installed,
  }
  file {'/etc/ssl/certs/nginx.pem':
    source => 'puppet:///modules/base/certs/nginx.pem',
  }
  file {'/etc/ssl/certs/nginx-chain.pem':
    source => 'puppet:///modules/base/certs/nginx-chain.pem',
  }
  file {'/etc/ssl/private/nginx.pem':
    source => 'puppet:///modules/base/private/nginx.pem',
  }
  user {'droyo':
    managehome => true,
    tag => ['gophers', 'web'],
  }
}
