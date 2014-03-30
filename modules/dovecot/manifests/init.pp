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

  @file{'/etc/dovecot/sieve':
    ensure => directory,
    owner => 'dovecot',
    group => 'dovecot',
    require => Package['dovecot'],
  }

  dovecot::sieve{'10-mailing-list':
    source => 'puppet:///modules/dovecot/ml.sieve',
  }
  dovecot::sieve{'05-spam-checker':
    source => 'puppet:///modules/dovecot/spam.sieve',
  }
  
  service {'dovecot':
    ensure => running,
    enable => true,
    require => Package['dovecot','dovecot-pigeonhole'],
  }
  cron {'expunge trash e-mails':
    user => 'root',
    command => 'doveadm expunge -A mailbox Trash savedbefore 30d',
  }
}
