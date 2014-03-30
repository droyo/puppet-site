node default {
  include base
  include plan9port
  include golang
  include werc
  
  class{'nginx':
    dhparam_length => 2048,
  }
  class{'gogive':
    port => 9265,
    paths => {
      '/exp/ndb' => 'git git://github.com/droyo/go.ndb.git',
      '/exp/soap' => 'git git://github.com/droyo/go.soap.git',
      '/exp/display' => 'git git://github.com/droyo/go.display.git',
      '/exp/gl' => 'git git://github.com/droyo/go.gl.git',
      '/cmd/gogive' => 'git git://github.com/droyo/gogive.git',
      '/cmd/webhook' => 'git git://github.com/droyo/webhook.git',
    },
  }
  class{'dovecot':
    version => latest,
  }
  class{'postfix':
    tls_cert => '/etc/pki/dovecot/certs/dovecot.pem',
    tls_key => '/etc/pki/dovecot/private/dovecot.pem',
    require => Class['dovecot'],
  }
  
  nginx::redirect{'https':
    root => '/var/empty',
    listen => 80,
    server_name => 'www.aqwari.net aqwari.net',
    redirect => 'https://$host$request_uri;',
  }
  nginx::ssl_server{'werc':
    server_name => 'www.aqwari.net aqwari.net',
    listen => 443,
    root => '/web/sites/aqwari.net',
    ssl_certificate => '/etc/pki/tls/certs/nginx.pem',
    ssl_certificate_key => '/etc/pki/tls/private/nginx.pem',
    ssl_trusted_certificate => '/etc/pki/tls/certs/startss-chain.pem',
    error_page => { 404 => '@werc' },
    locations => {
      '/' => '
        proxy_set_header Host $host;
        if ($args = "go-get=1") {
            proxy_pass http://localhost:9265;
        }
        try_files $uri @werc;',
      '/pub' => '
        root /web;
        try_files $uri =404;',
      '/favicon.ico' => '
        root /web;
        try_files /pub/$uri =404;',
      '@werc' => '
        include fastcgi_params;
        fastcgi_pass localhost:3333;
        fastcgi_cache NAME;
        fastcgi_cache_valid 200 302 1h;
        fastcgi_cache_valid 301 1d;
        fastcgi_cache_valid any 5m;
        fastcgi_cache_min_uses 1;
        fastcgi_cache_use_stale error timeout invalid_header http_500;',
    },
  }

  cron{'expunge old mailing list e-mails':
    user => 'droyo',
    command => 'doveadm expunge mailbox ml.% savedbefore 90d',
    hour => 4,
  }
}
 
