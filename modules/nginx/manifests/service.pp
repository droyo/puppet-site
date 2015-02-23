class nginx::service {
  private()
  service {'nginx':
    ensure => running,
    enable => true,
    require => File['/etc/pki/tls/private/nginx-dhparam.pem'],
  }
}
