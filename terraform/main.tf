provider "aws" {
 access_key = "ACCESS_KEY_HERE"
 secret_key = "SECRET_KEY_HERE"
 region = "${var.region}"
}

#######################
# Build VPC and Subnet
#######################

# create vpc
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

# create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

# create subnet public
resource "aws_subnet" "subnet_public" {
  count = "${length(var.cidr_subnet)}"

  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(values(var.cidr_subnet), count.index)}"
  map_public_ip_on_launch = "true"
  depends_on              = ["aws_internet_gateway.igw"]
  availability_zone       = "${element(keys(var.cidr_subnet), count.index)}"
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

# create route table
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
  tags {
      "sre_candidate" = "${var.sre_candidate_tag}"
    }
}

# associate route table with subnet public
resource "aws_route_table_association" "rta_subnet_public" {
  count = "${length(var.cidr_subnet)}"

  subnet_id      = "${element(aws_subnet.subnet_public.*.id,count.index)}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

###############################
# create an EC2 security group
###############################

# create security group
resource "aws_security_group" "sg_22" {
  name = "sg_22"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

resource "aws_security_group" "sg_80" {
  name = "sg_80"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

resource "aws_security_group" "sg_443" {
  name = "sg_443"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

resource "aws_security_group" "sg_8140" {
  name = "sg_8140"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 8140
      to_port     = 8140
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

resource "aws_security_group" "sg_22_int" {
  
  name = "sg_sg_22_int"
  vpc_id = "${aws_vpc.vpc.id}"
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

resource "aws_security_group_rule" "allow_ssh_int" {
  count = "${length(var.cidr_subnet)}"

  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["${element(values(var.cidr_subnet), count.index)}"]

  security_group_id = "${aws_security_group.sg_22_int.id}"
}

#######################################
# create key pair for SSH to our EC2
#######################################
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = "${file("${path.module}/(var.public_key_path)")}"
  public_key = "${file(var.public_key_path)}"
}
