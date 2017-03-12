define gcsfuse::mount(
  $bucket,
  $mountpoint = $name,
  $user       = undef,
) {
  require ::gcsfuse
  if $user {
    User<|title == $user|> -> Exec["gcsfuse mount ${name}"]
  }
  file{$mountpoint:
    ensure => directory,
    owner => $user,
  } ->
  exec{"gcsfuse mount ${name}":
    command => "/usr/bin/gcsfuse '${bucket}' '${mountpoint}'",
    user    => $user,
    unless  => "/bin/grep -E '${bucket}.*${mountpoint}' /proc/mounts",
  }
}
