define dovecot::sieve($source = undef, $content = undef) {
  realize File['/etc/dovecot/sieve']

  $src = "/etc/dovecot/sieve/${name}.sieve"
  $bin = "/etc/dovecot/sieve/${name}.svbin"

  file{$src:
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => $source,
    content => $content,
  } ~>
  exec{"/bin/rm -f ${bin}":
    refreshonly => true,
  }

  exec{"compile ${name}.sieve":
    environment => ['HOME=/var/empty'],
    command => "/usr/bin/sievec ${src} ${bin}",
    creates => $bin,
    logoutput => on_failure,
    require => File[$src],
  }
}
