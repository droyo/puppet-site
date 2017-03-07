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
