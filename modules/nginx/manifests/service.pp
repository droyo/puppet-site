class nginx::service {
  private()
  service {'nginx':
    ensure => running,
    enable => true,
    require => File['/etc/ssl/private/nginx-dhparam.pem'],
  }
}
