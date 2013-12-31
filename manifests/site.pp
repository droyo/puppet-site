import "nodes"

File {
  owner => 'root',
  group => 'root',
  mode => '0644',
}

Exec {
  path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
}

resources {'firewall':
  purge => true,
}

stage{'packages':
  before => Stage['main'],
}

class {'packages':
  stage => packages,
}
