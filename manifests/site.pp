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
    '/exp/ndb' => 'git git://github.com/droyo/go.ndb.git',
    '/encoding/ndb' => 'git git://github.com/droyo/go.ndb.git',
    '/exp/soap' => 'git git://github.com/droyo/go.soap.git',
    '/exp/display' => 'git git://github.com/droyo/go.display.git',
    '/exp/gl' => 'git git://github.com/droyo/go.gl.git',
    '/xml' => 'git git://github.com/droyo/go-xml.git',
    '/cmd/gogive' => 'git git://github.com/droyo/gogive.git',
    '/cmd/webhook' => 'git git://github.com/droyo/webhook.git',
    '/retry' => 'git git://github.com/droyo/retry.git',
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

nginx::ssl_server{'gogive':
  server_name => 'aqwari.net',
  listen => 443,
  root => '/var/empty',
  ssl_certificate => '/etc/pki/tls/certs/nginx.pem',
  ssl_certificate_key => '/etc/pki/tls/private/nginx.pem',
  ssl_trusted_certificate => '/etc/pki/tls/certs/startss-chain.pem',
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
nginx::ssl_server{'blog':
  server_name => 'blog.aqwari.net',
  listen => 443,
  root => '/srv/www',
  ssl_certificate => '/etc/pki/tls/certs/nginx.pem',
  ssl_certificate_key => '/etc/pki/tls/private/nginx.pem',
  ssl_trusted_certificate => '/etc/pki/tls/certs/startss-chain.pem',
}
nginx::ssl_server{'camlistore':
  server_name => 'camlistore.aqwari.net',
  listen => 443,
  root => '/var/empty',
  ssl_certificate => '/etc/pki/tls/certs/nginx.pem',
  ssl_certificate_key => '/etc/pki/tls/private/nginx.pem',
  ssl_trusted_certificate => '/etc/pki/tls/certs/startss-chain.pem',
  locations => {
      '/' => '
        auth_pam    "User login";
        auth_pam_service_name "camlistore";
        proxy_pass http://localhost:3179;',
  },
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

cron{'expunge old trash e-mails':
  user => 'droyo',
  command => 'doveadm expunge mailbox Trash savedbefore 30d',
  hour => 2,
}

cron{'expunge old mailing list e-mails':
  user => 'droyo',
  command => 'doveadm expunge mailbox ml.% savedbefore 90d',
  hour => 4,
}
