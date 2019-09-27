# dbzl-test-1

architecture

  - ---------------------------------
  |    LOAD BALANCER
  |        |
  |        |
  | --------------- 
  | | WS1  |    WS2|
  | ---------------- [multi zone]
  |
  |      |PUPPET|    
  |---------------------------------
BASTION 

#Terraform
terraform init
terraform plan
terraform apply

#output
bastion_ids = i-xxxxx0a5bd67cbb4c
bastion_public_ip = [
    34.xxx.208.xxx
]
puppet_master = [
    10.10.0.42
]
rtable_ids = rtb-0945a3ba5d75a46fb
subnet_ids = [
    subnet-xxx2c5da883e155bd,
    subnet-xxxfd249eb52da5ef
]
vpc_ids = vpc-xxxx1bb105f2f464d
webserver_ids = [
    i-xxxxa92a6ba12954c,
    i-xxxx282fde22ebc82
]
webserver_private_ip = [
    10.10.0.64,
    10.10.1.17
]
webserver_public_ip = [
    34.xxx.251.xxx,
    54.xxx.205.xxx
]

# puppet setup
## on client
chmod +x install.sh
./install.sh slave bastion|webserver
./install.sh add-master [master ip-address]

## on master
chmod +x install.sh
./install.sh master master

accessing the LB
http://web-server-lb-667690712.eu-west-1.elb.amazonaws.com/
