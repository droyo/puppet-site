File {
  owner => 'root',
  group => 'root',
  mode => '0644',
}

Exec {
  path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
}


if versioncmp($::puppetversion,'3.6.1') >= 0 {
  $allow_virtual_packages = hiera('allow_virtual_packages',false)
  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

resources {'firewall':
  purge => true,
}

include base
include firewall

class{'golang':
  path => '/usr/local/go',
}

include hugo

class{'nginx':
  dhparam_length => 2048,
}
class{'gogive':
  port => 9265,
  paths => {
    '/exp/ndb' => 'git https://github.com/droyo/go.ndb',
    '/encoding/ndb' => 'git https://github.com/droyo/go.ndb',
    '/exp/soap' => 'git https://github.com/droyo/go.soap',
    '/exp/display' => 'git https://github.com/droyo/go.display',
    '/exp/gl' => 'git https://github.com/droyo/go.gl',
    '/xml' => 'git https://github.com/droyo/go-xml',
    '/cmd/gogive' => 'git https://github.com/droyo/gogive',
    '/cmd/webhook' => 'git https://github.com/droyo/webhook',
    '/retry' => 'git https://github.com/droyo/retry',
    '/net/styx' => 'git https://github.com/droyo/styx',
  },
}
nginx::redirect{'https':
  root => '/var/empty',
  listen => 80,
  server_name => '*.aqwari.net aqwari.net',
  redirect => 'https://$host$request_uri;',
}

nginx::ssl_server{'root':
  server_name => 'aqwari.net',
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

nginx::ssl_server{'blog':
  server_name => 'blog.aqwari.net',
  listen => 443,
  root => '/srv/www',
  ssl_certificate => '/etc/ssl/certs/nginx.pem',
  ssl_certificate_key => '/etc/ssl/private/nginx.pem',
  ssl_trusted_certificate => '/etc/ssl/certs/nginx-chain.pem',
}

vcsrepo{'/srv/hugo':
  ensure   => 'present',
  owner    => 'hugo',
  group    => 'hugo',
  provider => 'git',
  source   => 'git://github.com/droyo/blog.git',
  require  => Class['hugo::user'],
}

Vcsrepo['/srv/hugo'] -> Class['hugo']
