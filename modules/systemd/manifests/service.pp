define systemd::service(
  $command,
  $runlevel    = 'multi-user.target',
  $user        = undef,
  $group       = undef,
  $ensure      = running,
  $enable      = true,
  $description = "Service ${name}",
  $directory   = '/var/empty',
  $restart     = false,
) {
  file{"/etc/systemd/system/${name}.service":
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
    User<|title == @user|> -> File["/etc/systemd/system/${name}.service"]
  }
  if $group {
    Group<|title == @group|> -> File["/etc/systemd/system/${name}.service"]
  }
}
