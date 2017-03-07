class nginx::dhparam {
  exec{'generate dhparam':
    command => "openssl dhparam -out /etc/ssl/private/nginx-dhparam.pem -rand – ${dhparam_length}",
    creates => '/etc/ssl/private/nginx-dhparam.pem',
  } ->
  file{'/etc/ssl/private/nginx-dhparam.pem':
    mode => '0600',
  }
}
