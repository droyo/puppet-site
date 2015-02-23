class nginx::config inherits nginx {
  private()
  @firewall {'301 HTTP':
    proto => 'tcp',
    port => 80,
    action => accept,
  }
  @firewall {'302 HTTPS':
    proto => 'tcp',
    port => 443,
    action => accept,
  }
  
  exec{'generate dhparam':
    command => "openssl dhparam -out /etc/pki/tls/private/nginx-dhparam.pem -rand – ${dhparam_length}",
    creates => '/etc/pki/tls/private/nginx-dhparam.pem',
  } ->
  file{'/etc/pki/tls/private/nginx-dhparam.pem':
    mode => '0600',
  }
  file {'/etc/nginx' :
    ensure => directory,
  }
  file {'/etc/nginx/conf.d':
    ensure => directory,
    recurse => true,
    purge => true,
  }
  file {'/etc/nginx/nginx.conf':
    content => template('nginx/nginx.conf.erb'),
    notify => Service['nginx'],
  }
}
