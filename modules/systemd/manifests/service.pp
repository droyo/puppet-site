define systemd::service(
  $command,
  $runlevel    = 'multi-user.target',
  $user        = undef,
  $group       = undef,
  $ensure      = running,
  $enable      = true,
  $description = "Service ${name}",
  $directory   = '/var/empty',
  $respawn     = false,
  $umask       = '022',
) {
  file{"/usr/lib/systemd/system/${name}.service":
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('systemd/service.erb'),
  } ~>
  service{"${name}.service":
    ensure => $ensure,
    enable => $enable,
  }
  
  # Autorequire user/group resources.
  if $user {
    User<|title == $user|> -> File["/usr/lib/systemd/system/${name}.service"]
  }
  if $group {
    Group<|title == $group|> -> File["/usr/lib/systemd/system/${name}.service"]
  }
}
