class nginx::package {
  include yumrepos::nginx
  
  package {'nginx':
    ensure => installed,
    require => Class['yumrepos::nginx']
  }
}
