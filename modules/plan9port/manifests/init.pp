class plan9port(
  $basedir = '/usr/local/plan9',
) {
  file {$basedir:
    ensure => directory,
  } ->
  exec {'hg clone https://code.swtch.com/plan9port .':
    cwd => $basedir,
    creates => "${basedir}/.hg",
    require => Package['mercurial'],
    logoutput => on_failure,
    timeout => 0,
  } ->
  exec {"${basedir}/INSTALL":
    cwd => $basedir,
    creates => "${basedir}/bin/rc",
    require => Package['gcc'],
    logoutput => on_failure,
    timeout => 0,
  }
  
  file {'/etc/profile.d/plan9.sh':
    mode => '0755',
    content => template('plan9port/profile.sh.erb'),
  }
}
