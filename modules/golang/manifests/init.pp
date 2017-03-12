# Installs official Go distribution at /usr/local/go
class golang {
  $version = '1.8'
  $arch = 'amd64'
  $tarball = "go${version}.linux-${arch}.tar.gz"
  $uri = "https://storage.googleapis.com/golang/${tarball}"

  $path = '/usr/local/go'
  $gopath = '/usr/local/gopath'

  file{$gopath:
    ensure => directory,
  }

  package{'golang':
    ensure => absent,
  }
  file{$path:
    ensure => directory,
  } ->
  exec{"curl -O '${uri}'":
    creates => "${path}/${tarball}",
    cwd     => $path,
  } ->
  exec{"tar --strip=1 -xzf '${tarball}'":
    cwd     => $path,
    creates => "${path}/VERSION",
  } ->
  file{'/usr/bin/go':
    ensure => link,
    target => "${path}/bin",
  }
}
