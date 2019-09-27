#!/bin/bash

if [ "$1" != "" ] ; then
 PARAM=$1
 DOMAIN=$2
 case $PARAM in
        master)
	  wget https://apt.puppet.test/puppet-tools-release-bionic.deb
	  sudo dpkg -i puppet-tools-release-bionic.deb                
	  sudo apt update
          sudo apt install puppet-master git -y

	  sudo hostnamectl set-hostname $DOMAIN".dbzl.test"
	  IPADDR=$(ifconfig | grep 10.10 | awk '{print $2}')
	  echo "$IPADDR  $PARAM.dbzl.test" | sudo tee -a /etc/hosts

	  git clone https://github.com/fazries/dbzl-test-1.git
	  cd dbzl-test-1/puppet
          sudo cp -r code /etc/puppet/
	  
	  cat /etc/hosts | grep "dbzl"

          ;;
        slave)
	  wget https://apt.puppet.test/puppet-tools-release-bionic.deb
	  sudo dpkg -i puppet-tools-release-bionic.deb                
	  sudo apt-get update
          sudo apt install puppet git -y

	  sudo hostnamectl set-hostname $DOMAIN".dbzl.test"
	  IPADDR=$(ifconfig | grep 10.10 | awk '{print $2}')
	  echo "$IPADDR  $DOMAIN.dbzl.test" | sudo tee -a /etc/hosts

	  git clone https://github.com/fazries/dbzl-test-1.git
	  cd dbzl-test-1/puppet
          sudo cp client/puppet.conf /etc/puppet/

	  cat /etc/hosts | grep "dbzl"

          ;; 
        add-master)
	  #add master ip address and domain
	  echo "$2  master.dbzl.test" | sudo tee -a /etc/hosts

          ;;		
        *)
          echo "ERROR: unknown parameter \"$PARAM\""
          exit 1
         ;;
 esac
fi

