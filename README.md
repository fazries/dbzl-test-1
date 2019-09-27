# dbzl-test-1

## building an architecture using Terraform
### architecture

```
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
```

### Terraform
```
terraform init
terraform plan
terraform apply
```
it will create several instance
- bastion-0
- puppet-master-0
- Webserver-1
- Webserver-2
- web-server-tg target group
- load balancer

### output
```
bastion_ids = i-xxxxx0a5bd67cbb4c
bastion_public_ip = [34.xxx.208.xxx]
puppet_master = [10.10.0.42]
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
```
## Accessing the server
### Bastion
```
cd dbzl-test-1/terraform/pem
ssh -i bastion ubuntu@bastio_ip_address
```
From bastion you can access to webserver-1,webserver-2 and puppet-master. the application layer only can be access from inside or private subnet


# Configuration Management
## puppet setup
### on client
```
chmod +x install.sh
./install.sh slave bastion|webserver
./install.sh add-master [master ip-address]
```
## on master
```
chmod +x install.sh
./install.sh master master
```
update /etc/hosts both on master and client

# accessing the LB
### http://web-server-lb-667690712.eu-west-1.elb.amazonaws.com/
