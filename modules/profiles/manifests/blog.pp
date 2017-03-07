class profiles::blog {  
  include hugo
  nginx::ssl_server{'blog':
    server_name => 'blog.aqwari.net',
    listen => 443,
    root => '/srv/hugo/public',
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
}
