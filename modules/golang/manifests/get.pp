# Install a go program to /usr/local/bin
define golang::get($binary = regsubst($name, '.*/', '')) {
  require golang
  
  exec {"${golang::path}/bin/go get ${name}":
    environment => [
        "GOPATH=${golang::gopath}",
        "GOBIN=/usr/local/bin",
    ],
    logoutput => on_failure,
    creates => "/usr/local/bin/${binary}",
    require => Package['golang', 'git'],
  }
}
