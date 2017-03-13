class hugo::package {
  if $::osfamily == 'Debian' {
    $pkgurl = 'https://github.com/spf13/hugo/releases/download/v0.17/hugo_0.17-64bit.deb'
    $pkgname = regsubst($pkgurl, '.*/', '')

    exec{'mkdir -p /var/cache/apt/archives':
      creates => '/var/cache/apt/archives',
    } ->
    exec{"curl -O '${pkgurl}'":
      cwd => '/var/cache/apt/archives',
      creates => "/var/cache/apt/archives/${pkgname}",
    } ->
    package{'hugo':
      ensure => '0.17',
      source => "/var/cache/apt/archives/${pkgname}",
      provider => dpkg,
    }
  } else {
    golang::get{'github.com/spf13/hugo':}
  }
}
