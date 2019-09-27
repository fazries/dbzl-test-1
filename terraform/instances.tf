###################################################################
# create EC2 Webserver instance 
# within public subnet with created key pair and security group
###################################################################


# create EC2 bastion
resource "aws_instance" "puppet_master" {
  count         = "1"

  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${element(aws_subnet.subnet_public.*.id,count.index)}"
  vpc_security_group_ids = [
      "${aws_security_group.sg_22.id}",
      "${aws_security_group.sg_8140.id}"
      ]
  key_name      = "${aws_key_pair.ec2key.key_name}"
  tags {
   "sre_candidate" = "${var.sre_candidate_tag}"
   "Name"          = "puppet-master-${count.index}"
 }
  connection {
    type = "ssh"
    user = "ubuntu"
 }

}

resource "aws_instance" "web_server" {
  count        = "${var.web_server_count}"

  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${element(aws_subnet.subnet_public.*.id,count.index)}"
  vpc_security_group_ids = [
      "${aws_security_group.sg_80.id}",
      "${aws_security_group.sg_443.id}",
      "${aws_security_group.sg_22_int.id}",
      "${aws_security_group.sg_8140.id}"
      ]
  key_name      = "${aws_key_pair.ec2key.key_name}"
  tags {
   "sre_candidate" = "${var.sre_candidate_tag}"
   "Name"          = "Web-server-${count.index}"
 }
}

# create EC2 bastion
resource "aws_instance" "bastion" {
  count        = "1"

  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${element(aws_subnet.subnet_public.*.id,count.index)}"
  vpc_security_group_ids = [
      "${aws_security_group.sg_22.id}",
      "${aws_security_group.sg_8140.id}"
      ]
  key_name      = "${aws_key_pair.ec2key.key_name}"
  tags {
   "sre_candidate" = "${var.sre_candidate_tag}"
   "Name"          = "bastion-${count.index}"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
 }
}

##########################
# create load balancer
##########################

resource "aws_lb" "web_server_lb" {
  name               = "web-server-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg_80.id}"]
  subnets            = ["${aws_subnet.subnet_public.*.id}"]

  enable_deletion_protection = false

  tags = {
    "sre_candidate" = "${var.sre_candidate_tag}"
  }
}

resource "aws_lb_target_group" "web_server_tg" {
  name     = "web-server-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_lb_target_group_attachment" "web_server_tg_att" {
  count        = "${var.web_server_count}"

  target_group_arn = "${aws_lb_target_group.web_server_tg.arn}"
  target_id        = "${element(aws_instance.web_server.*.id, count.index)}"
  port             = 80
}

resource "aws_lb_listener" "ws_listener" {
  load_balancer_arn = "${aws_lb.web_server_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_server_tg.arn}"
  }
}
