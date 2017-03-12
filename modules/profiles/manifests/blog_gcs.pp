# Generates hugo blog and uploads it to a GCS bucket
class profiles::blog_gcs {
  include ::hugo
  vcsrepo{'/srv/hugo':
    ensure   => 'present',
    owner    => 'hugo',
    group    => 'hugo',
    provider => 'git',
    source   => 'git://github.com/droyo/blog.git',
    require  => Class['::hugo::user'],
  }
  cron{'upload blog to GCS bucket':
    minute  => fqdn_rand(60),
    command => '/bin/sh -c "gsutil -m cp -r /srv/hugo/public/* gs://blog.aqwari.net"',
    user    => 'hugo',
  }
  Vcsrepo['/srv/hugo'] -> Class['::hugo']
}
