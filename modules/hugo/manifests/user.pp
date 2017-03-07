class hugo::user {
  user {'hugo':
    home => '/var/empty',
    shell => '/bin/false',
    tag => 'web',
  }
  group {'hugo':}
}
