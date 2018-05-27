define systemd::service(
  $command,
  $runlevel    = 'multi-user.target',
  $user        = undef,
  $group       = undef,
  $ensure      = running,
  $enable      = true,
  $description = "Service ${name}",
  $directory   = undef,
  $respawn     = false,
  $umask       = '022',
) {
  if $::osfamily == 'Debian' {
    if versioncmp($::operatingsystemrelease, '9') < 0 {
      $basedir = '/usr/lib/systemd'
    } else {
      $basedir = '/etc/systemd'
    }
  } else {
    $basedir = '/usr/lib/systemd'
  }
  file{"${basedir}/system/${name}.service":
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('systemd/service.erb'),
  } ~>
  service{$name:
    ensure => $ensure,
    enable => $enable,
  }
  
  # Autorequire user/group resources.
  if $user {
    User<|title == $user|> -> File["${basedir}/system/${name}.service"]
  }
  if $group {
    Group<|title == $group|> -> File["${basedir}/system/${name}.service"]
  }
}
