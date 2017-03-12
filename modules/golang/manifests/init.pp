# Installs official Go distribution at /usr/local/go
class golang {
  $version = '1.8'
  $arch = 'amd64'
  $tarball = "go${version}.linux-${arch}.tar.gz"
  $uri = "https://storage.googleapis.com/golang/${tarball}"

  $path = '/usr/local/go'

  package{'golang':
    ensure => absent,
  }
  file{$path:
    ensure => directory,
  } ->
  exec{"/usr/bin/curl -O '${uri}'":
    creates => "${path}/${tarball}",
    cwd     => $path,
  } ->
  exec{"/bin/tar --strip=1 -xzf '${tarball}'"
    cwd    => $path,
    onlyif => "/bin/test '${tarball}' -nt VERSION",
  } ->
  file{'/usr/bin/go':
    ensure => link,
    target => "${path}/bin",
  }
}
