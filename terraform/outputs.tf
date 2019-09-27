output "vpc_ids" {
    value = "${aws_vpc.vpc.id}"
}

output "subnet_ids" {
    value = "${aws_subnet.subnet_public.*.id}"
}

output "rtable_ids" {
    value = "${aws_route_table.rtb_public.id}"
}

output "webserver_ids" {
    value = "${aws_instance.web_server.*.id}"
}

output "webserver_public_ip" {
    value = "${aws_instance.web_server.*.public_ip}"
}

output "webserver_private_ip" {
    value = "${aws_instance.web_server.*.private_ip}"
}

output "puppet_master" {
    value = "${aws_instance.puppet_master.*.private_ip}"
}

output "bastion_ids" {
    value = "${aws_instance.bastion.id}"
}

output "bastion_public_ip" {
    value = "${aws_instance.bastion.*.public_ip}"
}

output "Load balancer DNS Name" {
    value = "${aws_lb.web_server_lb.dns_name}"
}
