class gcsfuse {
  if $::osfamily == 'Debian' {
    $uri = 'http://packages.cloud.google.com/apt'
    $dist = "gcsfuse-${::lsbdistcodename}"
    file{'/etc/apt/sources.list.d/gcsfuse.list':
      owner => 'root',
      group => 'root',
      mode => '0644',
      content => "deb ${uri} ${dist} main\n",
    } ~>
    exec{'(gcsfuse) apt-get update':
      command => 'apt-get update',
      refreshonly => true,
    } ->
    package{'gcsfuse':
      ensure => 'installed',
    }
  }
}
