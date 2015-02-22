# upstart::service defines an upstart job. It also creates an init.d
# wrapper to avoid surprising old-fashioned administrators. Users
# have the option of defining an upstart job file explicitly, or
# Generating a file for simple use cases
# Some examples:
#
# upstart::service{'diamond':
#   desc => "System statistics collector for graphite",
#   user => diamond,
#   command => '/usr/bin/diamond --foreground',
# }

define upstart::service(
  $ensure  = running,
  $desc    = false,
  $user    = false,
  $group   = false,
  $umask  = false,
  $command = false,
  $environment = undef,
  $content = false,
  $source  = false,
  $respawn = false,
  $directory = false,
  $secondary_groups = false
) {
  require upstart
  
  file {"/etc/init/${title}.conf":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$title],
  }
  
  service {$title:
    ensure    => $ensure,
    hasstatus => false,
    restart   => "/sbin/restart ${title}",
    start     => "/sbin/start ${title}",
    stop      => "/sbin/start ${title}",
    status    => "/sbin/status ${title} | grep -q '${title} start/running'",
    require   => File['/usr/local/bin/setuidgid.py'],
  }
  
  file {"/etc/rc.d/init.d/${title}":
    owner => 'root',
    group => 'root',
    mode  => '0755',
    source => 'puppet:///modules/upstart/wrapper.init',
  }
  
  if $content or $source {
    if $content and $source {
      fail('Cannot specify both $source and $content')
    }
    if $user or $group or $secondary_groups or $command or $respawn or $desc or $directory or $umask or $environment {
      fail('Use of $content or $source precludes use of other arguments')
    }
    if $content {
      File["/etc/init/${title}.conf"] {
        content => $content,
      }
    } else {
      File["/etc/init/${title}.conf"] {
        source => $source,
      }
    }
  } else {
    if ! $command {
      fail("Must specify a command to run for service ${name}")
    }
    File["/etc/init/${title}.conf"] {
      content => template('upstart/upstart.erb'),
    }
  }
}
