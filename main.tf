module "jhc_vpc" {
  source = "./modules/networking"
  vpc_tags = {
    Name = "jhc-app"

  }
}
module "webapp" {
  source     = "./modules/ec2"
  ami        = "ami-051f7e7f6c2f40dc1"
  key_name   = "amazon"
  vpc_id     = module.jhc_vpc.vpc_id
  subnet_ids = module.jhc_vpc.pub_sub_ids
  web_ingress_rules = {
    "22" = {
      port     = 22
      protocol = "tcp"
      #generally we provide the ip address/security group of the server which connects to this 
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow ssh"

    }
    "80" = {
      port     = 80
      protocol = "tcp"
      #generally we provide the ip address/security group of the server which connects to this 
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow 80 everywhere"
    }
  }

}

module "myappalb" {
  source     = "./modules/alb"
  vpc_id     = module.jhc_vpc.vpc_id
  subnet_ids = module.jhc_vpc.pub_sub_ids
  alb_ingress_rules = {
    "80" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow 80 everywhere"
    }
  }
}