provider "aws" {
  region = var.global_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-1b", "us-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name        = "terraform"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_security_group" "bastion_sg" {
  description = "Enable SSH access to the bastion via SSH port"
  name        = "bastion-security-group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG for private instances
resource "aws_security_group" "private_instances_sg" {
  description = "Enable SSH access to the Private instances from the bastion via SSH port"
  name        = "private-security-group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    protocol  = "TCP"
    to_port   = 22

    security_groups = [
      "${aws_security_group.bastion_sg.id}",
    ]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}"]
  subnet_id                   = "${module.vpc.public_subnets[0]}"

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y wget curl git nmap lsof 
    EOF

  tags = {
    Name        = "terraform"
    Environment = "dev"
    Terraform   = "true"
  }
}
