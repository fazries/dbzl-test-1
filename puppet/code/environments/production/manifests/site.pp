node default { }

node 'webserver-01.dbzl.test','webserver-02.dbzl.test' {
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

