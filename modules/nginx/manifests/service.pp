class nginx::service {
  assert_private()
  service {'nginx':
    ensure => running,
    enable => true,
    require => File['/etc/ssl/private/nginx-dhparam.pem'],
  }
}
