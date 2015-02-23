class yumrepos::epel{
  package{'epel-release':
    ensure => installed
  }
}
