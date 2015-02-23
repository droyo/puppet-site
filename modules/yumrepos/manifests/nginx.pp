class yumrepos::nginx{
  package{'nginx-release-centos':
    provider => rpm,
    source => 'http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm',
  }
}
