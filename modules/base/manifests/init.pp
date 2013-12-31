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
  
  package {['mercurial','git','bzr','gcc']:
    ensure => latest,
  }
  package {'w3m':
    ensure => installed,
  }
  file {'/etc/pki/tls/certs/startss-chain.pem':
    source => 'puppet:///modules/base/certs/startss-chain.pem',
  }
  file {'/etc/pki/tls/certs/nginx.pem':
    source => 'puppet:///modules/base/certs/nginx.pem',
  }
  file {'/etc/pki/tls/private/nginx.pem':
    source => 'puppet:///modules/base/private/nginx.pem',
  }
  user {'droyo':
    managehome => true,
    tag => ['gophers', 'web'],
  }
}
