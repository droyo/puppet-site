class roles::gce_backend {  
  include base
  include golang
  include profiles::gogive
  include profiles::webserver
  include profiles::blog_gcs
}
