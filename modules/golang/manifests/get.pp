# Install a go program to /usr/local/bin
define golang::get($binary = regsubst($name, '.*/', '')) {
  include golang
  
  exec {"go get ${name}":
    environment => "GOBIN=${golang::path}",
    logoutput => on_failure,
    creates => "/usr/local/bin/${binary}",
    require => Package['git','mercurial','bzr', 'golang'],
  }
}
