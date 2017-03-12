define gcsfuse::mount(
  $bucket,
  $mountpoint = $name,
  $user       = undef,
) {
  require ::gcsfuse
  if $user {
    User<|title == $user|> -> Exec["gcsfuse mount ${name}"]
  }
  exec{"gcsfuse mount ${name}":
    command => "/usr/bin/gcsfuse '${bucket}' '${mountpoint}'",
    user    => $user,
    unless  => "/bin/grep -E '${bucket}.*${mountpoint}' /proc/mounts",
  }
}
