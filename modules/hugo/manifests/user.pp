class hugo::user {
  private()
  user {'hugo':
    home => '/var/empty',
    shell => '/sbin/nologin',
    tag => 'web',
  }
  group {'hugo':}
}
