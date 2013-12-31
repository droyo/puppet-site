define nginx::redirect(
  $root,
  $listen,
  $server_name,
  $redirect = undef,
) {
  file {"/etc/nginx/conf.d/${name}.conf":
    content => template('nginx/redirect.conf.erb'),
    notify => Service['nginx'],
  }
}
