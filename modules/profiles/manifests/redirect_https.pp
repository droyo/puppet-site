class profiles::redirect_http {  
  nginx::redirect{'https':
    root => '/var/empty',
    listen => 80,
    server_name => '*.aqwari.net aqwari.net',
    redirect => 'https://$host$request_uri;',
  }
}
