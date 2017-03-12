class roles::do_backend {  
  include base
  include firewall
  include golang
  
  include profiles::gogive
  include profiles::redirect_https
  include profiles::ssl_webserver
  include profiles::sandstorm
  include profiles::blog
}
