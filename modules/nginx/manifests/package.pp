class nginx::package {
  if $::osfamily == 'RedHat' {
    include yumrepos::nginx
    Class['yumrepos::nginx'] -> Package['nginx']
  }
  package {'nginx':
    ensure => installed,
  }
}
