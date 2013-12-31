# = Class: firewall
#
# Manages packages and services required by the firewall type/provider.
#
# This class includes the appropriate sub-class for your operating system,
# where supported.
#
# == Parameters:
#
# [*ensure*]
#   Ensure parameter passed onto Service[] resources.
#   Default: running
#
class firewall (
  $ensure = running
) {
  include firewall::pre
  include firewall::post
  
  case $ensure {
    /^(running|stopped)$/: {
      # Do nothing.
    }
    default: {
      fail("${title}: Ensure value '${ensure}' is not supported")
    }
  }

  case $::kernel {
    'Linux': {
      class { "firewall::linux":
        ensure => $ensure,
      }
    }
    default: {
      fail("${title}: Kernel '${::kernel}' is not currently supported")
    }
  }
  
  Firewall <|tag != internal|> {
    before => Class['firewall::post'],
    require => Class['firewall::pre'],
  }
}
