provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "k8s-ground-up"
  }

  enable_dns_support   = true
  enable_dns_hostnames = true
}

