class gcsfuse {
  if $::osfamily == 'Debian' {
    $uri = 'http://packages.cloud.google.com/apt'
    $dist = "gcsfuse-${::lsbdistcodename}"
    file{'/etc/apt/sources.list.d/gcsfuse.list',
      owner => 'root',
      group => 'root',
      mode => '0644',
      content => "deb ${uri} ${dist} main\n",
    } ->
    package{'gcsfuse':
      ensure => 'installed',
    }
  }
}
