define dovecot::sieve($source = undef, $content = undef) {
  realize File['/var/lib/dovecot/sieve']

  file{"/var/lib/dovecot/sieve/${name}.sieve":
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => $source,
    content => $content,
  } ~> Exec['compile sieve scripts']
}
