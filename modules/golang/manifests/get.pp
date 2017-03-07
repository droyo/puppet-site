# Install a go program to /usr/local/bin
define golang::get($binary = regsubst($name, '.*/', '')) {
  include golang
  
  exec {"go get ${name}":
    environment => [
        "GOPATH=${golang::path}",
        "GOBIN=/usr/local/bin",
    ],
    logoutput => on_failure,
    creates => "/usr/local/bin/${binary}",
    require => Package['golang', 'git'],
  }
}
