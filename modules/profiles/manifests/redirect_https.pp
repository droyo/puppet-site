class profiles::redirect_https {
  ::nginx::redirect{'https':
    root => '/var/empty',
    listen => 80,
    server_name => '*.aqwari.net aqwari.net',
    redirect => 'https://$host$request_uri;',
  }
}
