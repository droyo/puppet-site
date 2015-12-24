class postfix(
  $tls_cert,
  $tls_key,
  $tls_session_cache_timeout = '300s',
  $myhostname = "mail.${::fqdn}",
  $mydomain = $::fqdn,
) {
  package{'postfix':
    ensure => latest,
  }
  package {'spamassassin':
    ensure => latest,
  }
  file {'/etc/postfix':
    ensure => directory,
  }
  file {'/etc/postfix/main.cf':
    content => template('postfix/main.cf.erb'),
    notify => Service['postfix'],
  }
  file {'/etc/postfix/master.cf':
    content => template('postfix/master.cf.erb'),
  }
  @firewall{'25 SMTP':
    proto  => 'tcp',
    port   => 25,
    action => accept,
  }
  service {'postfix':
    ensure => running,
    enable => true,
    require => [
      Package['postfix'],
      Package['spamassassin'],
      File['/etc/postfix/main.cf'],
      File['/etc/postfix/master.cf'],
    ],
  }
}
