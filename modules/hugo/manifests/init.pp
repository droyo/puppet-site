class hugo ($basedir = '/srv/www') {
  require golang
  include hugo::user
    
  file {['/srv/hugo', '/srv/www']:
    ensure => 'directory',
    owner  => 'root',
    group  => 'web',
    mode   => '2775',
  }
  webhook::hook{'hugo':
    user      => 'hugo',
    group     => 'web',
    port      => '3950',
    directory => '/srv/hugo',
    command   => 'git pull origin master',
  }
  cron{'pull hugo updates':
    minute  => '*/10',
    command => '/bin/sh -c "cd /srv/hugo && git pull origin master 2>&1| logger -t hugo"',
    user    => 'hugo',
  }
  
  golang::get{'github.com/spf13/hugo':}
  include hugo::service
}
