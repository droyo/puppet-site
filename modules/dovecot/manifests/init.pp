class dovecot(
  $version = latest,
  $auth_mech = ['plain', 'login'],
  $ssl_cert = '/etc/pki/dovecot/certs/dovecot.pem',
  $ssl_key = '/etc/pki/dovecot/private/dovecot.pem',
) {
  @firewall {'143 IMAP':
    proto => 'tcp',
    port => 143,
    action => accept,
  }
  
  file {'/etc/dovecot':
    ensure => directory,
  }
  
  file { '/etc/dovecot/dovecot.conf':
    content => template('dovecot/dovecot.conf.erb'),
    notify  => Service['dovecot'],
  }
  
  package { 'dovecot':
    ensure => $version,
  } ->
  package { 'dovecot-pigeonhole':
    ensure => installed,
  }
  
  service {'dovecot':
    ensure => running,
    enable => true,
    require => Package['dovecot','dovecot-pigeonhole'],
  }
}
