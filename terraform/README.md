# Terraform scripts

## Quickstart

Scripts can easily be run with 
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

# File and Resource descriptions
## vpc.tf
This Terraform file creates a Virtual Private Cloud (VPC) in AWS, where all the other resources like EC2 instances, subnets, route tables, etc., will be deployed.
- `aws_vpc`: The VPC resource block defines the setup for a Virtual Private Cloud in AWS which provides the networking environment for all the other resources.

## internet-gateway.tf
This Terraform file creates and attaches an Internet Gateway to the previously defined VPC, enabling communication between instances in the VPC and the internet.
- `aws_internet_gateway`: This resource defines the creation of an Internet Gateway, which allows resources within the VPC to access the internet.

## private-subnet.tf
This file creates a private subnet within the VPC defined in `vpc.tf`, providing a separate network segment for launching AWS resources.
- `aws_subnet`: This resource defines the creation of a subnet within the VPC, which can be used to launch AWS resources in a specific subnet.

## route_table.tf
In this file, a route table is created within the VPC and associated with our subnet, with a default route set to the Internet Gateway to allow external access.
- `aws_route_table`: This resource creates a route table within the VPC and sets a route that directs all traffic (0.0.0.0/0) to the Internet Gateway.
- `aws_route_table_association`: This resource associates the created route table with the specified subnet.

## security_group.tf
This script creates a security group within the specified VPC, and it defines inbound rules to control incoming traffic to instances associated with the group.
- `aws_security_group`: This resource creates a security group within the VPC. It allows you to define rules for inbound traffic to instances associated with this group.

## key_pair.tf
This Terraform file creates an SSH key pair for the EC2 instances and writes the private key to a local file.
- `tls_private_key`: This resource creates a private and public key pair.
- `aws_key_pair`: This resource uploads the generated public key to AWS, allowing you to connect to your instances.

## load_balancer.tf
This Terraform file creates a network load balancer and a target group within the VPC.
- `aws_lb`: This resource creates a Network Load Balancer that automatically distributes incoming application traffic across multiple targets, such as EC2 instances.
- `aws_lb_target_group`: This resource creates a target group that the Network Load Balancer uses to route requests to one or more registered targets.

## controllers-ec2.tf
This file launches EC2 instances for the Kubernetes controllers, which manage the state of the Kubernetes cluster.
- `aws_instance`: This resource launches EC2 instances using the previously defined security group and key pair.

## workers-ec2.tf
This Terraform file launches EC2 instances for the Kubernetes workers, which run the applications deployed on the Kubernetes cluster.
- `aws_instance`: This resource launches EC2 instances using the previously defined security group and key pair.
