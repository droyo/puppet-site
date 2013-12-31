class packages {
  package{'nginx-release-centos':
    provider => rpm,
    source => 'http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm',
  }
}
