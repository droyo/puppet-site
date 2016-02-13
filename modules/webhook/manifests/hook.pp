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

  if $::osfamily == 'Debian' {
    upstart::service{"webhook-${name}":
      desc  => 'Github webhook receiver for $name',
      user  => $user,
      group => $group,
      command => "/usr/local/bin/webhook -a \"${addr}:${port}\" -f \"${filter}\" ${command}",
      respawn => true,
      directory => $directory,
    }
  } else {
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
}
