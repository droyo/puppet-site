class golang (
  $basedir = '/opt/go',
  $gopath = '/usr/local/go',
  $branch = 'release-go1.2'
) {
  group {'gophers':
    ensure => present,
  }
  User <|tag == 'gophers'|> {
    groups +> 'gophers',
    require +> Group['gophers'],
  }
  
  file {[$gopath, "${gopath}/src", "${gopath}/pkg"]:
    owner => 'root',
    group => 'gophers',
    mode => '2775',
  }
  file {$basedir:
    owner => 'root',
    group => 'root',
    mode => '0755',
    ensure => directory,
  }
  exec {"hg clone -u ${branch} https://code.google.com/p/go .":
    cwd => $basedir,
    creates => "${basedir}/.hg",
    require => Package['mercurial'],
    logoutput => on_failure,
  } ~>
  exec {"${basedir}/src/make.bash":
    cwd => "${basedir}/src",
    creates => "${basedir}/bin/go",
    require => Package['gcc'],
    logoutput => on_failure,
  }
  
  file {'/etc/profile.d/golang.sh':
    owner => 'root',
    group => 'root',
    mode => '0755',
    content => template('golang/profile.sh.erb'),
  }
}
