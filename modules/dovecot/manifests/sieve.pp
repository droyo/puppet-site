define dovecot::sieve($source) {
  realize File['/var/lib/dovecot/sieve']

  file{"/var/lib/dovecot/sieve/${name}.sieve":
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => $source,
  } ~> Exec['compile sieve scripts']
}
