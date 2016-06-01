class hugo::user {
  assert_private()
  user {'hugo':
    home => '/var/empty',
    shell => '/bin/false',
    tag => 'web',
  }
  group {'hugo':}
}
