class golang(
  $path = '/usr/local/go',
) {
  if $::osfamily == 'RedHat' {
    include yumrepos::epel
    Class['yumrepos::epel'] -> Package['golang']
  }
  
  file{$path:
    ensure => directory,
  }
  
  package{'golang':
    ensure => installed,
  }
}
