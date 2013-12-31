class firewall::post {
  firewall {'999 drop all':
    tag => internal,
    proto => 'all',
    action => 'drop',
    before => undef,
  }
}
