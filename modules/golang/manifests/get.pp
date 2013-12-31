# Install a go program to /usr/local/bin
define golang::get($binary = regsubst($name, '.*/', '')) {
  require golang
  
  exec {"${golang::basedir}/bin/go get ${name}":
    environment => 'GOBIN=/usr/local/bin',
    logoutput => on_failure,
    creates => "/usr/local/bin/${binary}",
    require => Package['git','mercurial','bzr'],
  }
}
