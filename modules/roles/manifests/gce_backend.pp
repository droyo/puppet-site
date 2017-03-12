class roles::gce_backend {  
  include base
  include golang
  include profiles::gogive
  include profiles::webserver
  include profiles::blog_gcs

  # Using preemptible instances, don't last longer than 24 hrs. No point running
  # the puppet agent.
  service{'puppet': ensure => stopped, enable => false }
}
