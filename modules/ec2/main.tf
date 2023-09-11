resource "aws_instance" "main" {
    count=var.ec2_count
    ami=var.ami
    associate_public_ip_address=var.public_ip
    instance_type=var.instance_type
    subnet_id=var.subnet_ids[count.index]
    vpc_security_group_ids=[aws_security_group.web.id]
    key_name=var.key_name
    user_data=file("${path.module}/scripts/httpd.sh")
    user_data_replace_on_change=true
    tags={
        Name="ec2-demo"
    }
  
}
#create security group for ec2
resource "aws_security_group" "web"{
    name="allow traffic for web"
    description="allow inbound traffic"
    vpc_id=var.vpc_id
    dynamic "ingress" {
        for_each=var.web_ingress_rules
        content{
            description="some description"
            from_port=ingress.value.port
            to_port=ingress.value.port
            protocol=ingress.value.protocol
            cidr_blocks=ingress.value.cidr_blocks
        }
    }
    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        ipv6_cidr_blocks=["::/0"]
    }
    tags={
        Name="ec2_security_rules"
    }
}