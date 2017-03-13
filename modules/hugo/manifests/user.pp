class hugo::user {
  user {'hugo':
    shell => '/bin/false',
    tag => 'web',
  }
  group {'hugo':}
}
