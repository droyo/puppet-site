class gcsfuse {
  if $::osfamily == 'Debian' {
    $uri = 'http://packages.cloud.google.com/apt'
    $dist = "gcsfuse-${::lsbdistcodename}"
    augeas{'add gcsfuse repo':
      context => "/files/etc/apt/sources.list.d/google-cloud.list/",
      changes => [
          "set *[distribution = '${dist}']/type deb",
          "set *[distribution = '${dist}']/uri '${uri}'",
          "set *[distribution = '${dist}']/distribution gcsfuse-${::lsbdistcodename}",
          "set *[distribution = '${dist}']/component main",
      ],
    } ->
    package{'gcsfuse':
      ensure => 'installed',
    }
  }
}
