define nginx::server(
  $root,
  $listen,
  $server_name,
  $error_page = {},
  $client_body_max_size = undef,
  $resolver = '8.8.8.8',
  $locations = {}
) {
  file {"/etc/nginx/conf.d/${name}.conf":
    content => template('nginx/server.conf.erb'),
    notify => Service['nginx'],
  }
}
