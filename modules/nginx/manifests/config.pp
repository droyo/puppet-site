class nginx::config inherits nginx {
  @firewall {'300 HTTP':
    proto => 'tcp',
    port => 80,
    action => accept,
  }
  @firewall {'300 HTTPS':
    proto => 'tcp',
    port => 443,
    action => accept,
  }
  
  $user = $::osfamily ? {
    default  => 'nginx',
    'Debian' => 'www-data',
  }
  exec{'generate dhparam':
    command => "openssl dhparam -out /etc/ssl/private/nginx-dhparam.pem -rand – ${dhparam_length}",
    creates => '/etc/ssl/private/nginx-dhparam.pem',
  } ->
  file{'/etc/ssl/private/nginx-dhparam.pem':
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
