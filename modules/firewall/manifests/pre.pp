class firewall::pre {
  Firewall {
    require => undef,
  }
  # Default firewall rules
  firewall { '000 accept all icmp':
    tag => internal,
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    tag => internal,
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    tag => internal,
    proto   => 'all',
    ctstate => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  } ->
  firewall { '003 accept ssh':
    tag => internal,
    proto => 'tcp',
    port => 22,
    action => accept,
  }
}
