# dbzl-test-1

## on client
chmod +x install.sh
./install.sh [master|slave] [domain]
./install.sh slave bastion|webserver
cd dbzl-test-1/terraform/pem
cp bastion ~/.ssh/id_rsa
chmod 700 ~/.ssh/id_rsa

./install.sh add-master [master ip-address]

## on master
chmod +x install.sh
./install.sh master master

* get master ip address
