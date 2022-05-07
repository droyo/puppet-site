class hugo::user {
  user {'hugo':
    shell => '/usr/sbin/nologin',
    tag => 'web',
    managehome => true,
  }
  group {'hugo':}
}
