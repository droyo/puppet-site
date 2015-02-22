define webhook::hook(
  $port,
  $addr,
  $command,
  $user   = 'nobody',
  $group  = 'nobody',
  $directory = '/var/empty',
  $filter = ''
) {
  include webhook
  include golang

  @firewall {"300 webhook ${name}":
    proto => 'tcp',
    port => $port,
    action => accept,
  }

  upstart::service{"webhook-${name}":
    desc  => 'Github webhook receiver for $name',
    user  => $user,
    group => $group,
    command => "${golang::gopath}/bin/webhook -a \"${addr}:${port}\" -f \"${filter}\" ${command}",
    respawn => true,
    directory => $directory,
  }
}
