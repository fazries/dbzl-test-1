node default { }

node '/^webserver\d+$/.dbzl.test' {
  # execute 'apt-get update'
  exec { 'apt update':                
   command => '/usr/bin/apt update' 
  }

  # install nginx package
  package { 'nginx':
    require => Exec['apt update'],
    ensure => installed,
  }

  # ensure nginx service is running
  service { 'nginx':
    ensure => running,
  }
}

node 'bastion.dbzl.test' {
  # execute 'apt-get update'
  exec { 'apt update':                
   command => '/usr/bin/apt update' 
  }

  # install nginx package
  package { 'nginx':
    require => Exec['apt update'],
    ensure => installed,
  }

  # ensure nginx service is running
  service { 'nginx':
    ensure => running,
  }
}

