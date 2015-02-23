class golang(
  $path = '/usr/local/go',
) {
  include yumrepos::epel
  
  file{$path:
    ensure => directory,
  }
  
  package{'golang':
    ensure => installed,
    require => Class['yumrepos::epel'],
  }
}
