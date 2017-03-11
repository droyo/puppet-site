define gcsfuse::mount(
  $bucket,
  $mountpoint = $name,
  $user       = undef,
) {
  require ::gcsfuse
  if $user {
    User<|title == $user|> ->
    exec{"/usr/sbin/usermod -a -G fuse ${user}":
      unless => "/usr/bin/groups $user | /bin/grep -q fuse",
      before => Exec["gcsfuse mount ${name}"],
    }
  }
  exec{"gcsfuse mount ${name}":
    command => "/usr/bin/gcsfuse '${bucket}' '${mountpoint}'",
    user    => $user,
    unless  => "/bin/grep -E '${bucket}.*${mountpoint}' /proc/mounts",
  }
}
