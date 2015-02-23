class golang(
  $path = '/usr/local/bin',
) {
  include yumrepos::epel
  package{'golang':
    ensure => installed,
    require => Class['yumrepos::epel'],
  }
}
