class profiles::webserver {  
  include ::nginx
  ::nginx::server{'root':
    server_name => 'aqwari.net www.aqwari.net',
    listen => 80,
    root => '/var/empty',
    locations => {
      '= /_health' => '
          return 204;',
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
