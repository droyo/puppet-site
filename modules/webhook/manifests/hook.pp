define webhook::hook(
  $port,
  $command,
  $addr = '',
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

  systemd::service{"webhook-${name}":
    description => 'Receive github webhook notifications',
    user        => $user,
    group       => $group,
    directory   => $directory,
    command     => inline_template('<% require "shellwords" -%>',
        '/usr/local/bin/webhook ',
        '-a <%= Shellwords.escape("#{@addr}:#{@port}") %> ',
        '-f <%= Shellwords.escape(@filter) %> ',
        '<%= @command %>'),
    require => Golang::Get['github.com/droyo/webhook'],
  }
}
