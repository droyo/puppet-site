class profiles::ssl_webserver {  

  class{'nginx':
    dhparam_length => 2048,
  }
  nginx::ssl_server{'root':
    server_name => 'aqwari.net www.aqwari.net',
    listen => 443,
    root => '/var/empty',
    ssl_certificate => '/etc/ssl/certs/nginx.pem',
    ssl_certificate_key => '/etc/ssl/private/nginx.pem',
    ssl_trusted_certificate => '/etc/ssl/certs/nginx-chain.pem',
    locations => {
      '= /artifactory-dircp' => '
          return 301 $scheme://blog.aqwari.net$request_uri;',
      '= /plumber-puppet' => '
          return 301 $scheme://blog.aqwari.net$request_uri;',
      '= /golibs' => '
          return 301 $scheme://blog.aqwari.net$request_uri;',
      '= /' => '
        return 307 $scheme://blog.aqwari.net;',
      '/' => '
        proxy_set_header Host $host;
        proxy_pass http://localhost:9265;',
    },
  }
}