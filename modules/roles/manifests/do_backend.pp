class roles::do_backend {  
  include base
  include firewall
  
  class{'golang':
    path => '/usr/local/go',
  }
  
  include profiles::gogive
  include profiles::redirect_https
  include profiles::ssl_webserver
  include profiles::sandstorm
  include profiles::blog
}
