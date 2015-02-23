class nginx(
  $worker_processes = 1,
  $worker_connections = 1024,
  $keepalive_timeout = 65,
  $gzip = true,
  $dhparam_length = 4096,
) {
  include nginx::config
  include nginx::service
  include nginx::package
  
  Class['nginx::package'] -> Class['nginx::service']
  Class['nginx::config'] -> Class['nginx::service']
}
