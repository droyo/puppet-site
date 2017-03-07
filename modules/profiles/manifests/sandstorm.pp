class sandstorm {
  nginx::ssl_server{'sandstorm':
    listen => 443,
    server_name => '*.aqwari.net *.aqwari.us',
    ssl_certificate => '/etc/ssl/certs/nginx.pem',
    ssl_certificate_key => '/etc/ssl/private/nginx.pem',
    hsts => true,
    client_body_max_size => '1024m',
    root => '/var/empty',
    locations => {
      '/' => '
          proxy_pass http://127.0.0.1:6080;
  	proxy_set_header Host $http_host;
  	proxy_http_version 1.1;
  	proxy_set_header Upgrade $http_upgrade;
  	proxy_set_header Connection $connection_upgrade;',
    },
  }
}
