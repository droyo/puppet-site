class upstart {
  file {'/usr/local/bin/setuidgid.py':
    owner => 'root',
    group => 'root',
    mode  => '0750',
    source => 'puppet:///modules/upstart/setuidgid.py',
  }
}
