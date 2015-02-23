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

  systemd::service{"webhook-${name}":
    description => 'Receive github webhook notifications',
    user        => $user,
    group       => $group,
    directory   => $directory,
    command     => inline_template('<% require "shellwords" -%>',
        "${golang::path}/webhook ",
        '-a <%= Shellwords.escape("#{@addr}:#{port}") %> ',
        '-f <%= Shellwords.escape(@filter) %> ',
        '<%= @command %>'),
  }
}
