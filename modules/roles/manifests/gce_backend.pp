class roles::gce_backend {  
  include base
  
  class{'golang':
    path => '/usr/local/go',
  }
  
  include profiles::gogive
  include profiles::webserver
  include profiles::blog_gcs
}
