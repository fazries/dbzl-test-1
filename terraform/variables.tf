variable "region" {
    description = "Region of the VPC"
    default = "eu-west-1"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.10.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  type= "map"
  default = {
      "eu-west-1a" = "10.10.0.0/24"
      "eu-west-1b" = "10.10.1.0/24"
      }
}

variable "public_key_path" {
  description = "Public key path"
  default = "pem/bastion.pub"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-06358f49b5839867c"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t3.small"
}

variable "sre_candidate_tag" {
  description = "SRE candidate tag"
  default = "setyadi"
}

variable "web_server_count" {
    description = "Number of instances need to be created"
    default = "2"
}
