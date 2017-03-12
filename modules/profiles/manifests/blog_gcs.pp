# Generates hugo blog and uploads it to a GCS bucket
class profiles::blog_gcs {
  include ::gcsfuse
  include ::hugo
  vcsrepo{'/srv/hugo':
    ensure   => 'present',
    owner    => 'hugo',
    group    => 'hugo',
    provider => 'git',
    source   => 'git://github.com/droyo/blog.git',
    require  => Class['::hugo::user'],
  } ->

  gcsfuse::mount{'/srv/hugo/public':
    user   => 'hugo',
    bucket => 'blog.aqwari.net',
  }

  Vcsrepo['/srv/hugo'] -> Class['::hugo']
  Vcsrepo['/srv/hugo'] -> Gcsfuse::Mount['/srv/hugo/public']
  Gcsfuse::Mount['/srv/hugo/public'] -> Class['::hugo::service']
}
