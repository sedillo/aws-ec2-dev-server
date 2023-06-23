resource "aws_instance" "worker" {
  count         = 3
  ami           = "ami-0f8e81a3da6e2510a"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.kubernetes.key_name

  vpc_security_group_ids = [
    aws_security_group.kubernetes_sg.id
  ]

  subnet_id = aws_subnet.my_subnet.id

  associate_public_ip_address = true

  private_ip = "10.0.1.2${count.index}"

  user_data = "name=worker-${count.index}|pod-cidr=10.200.${count.index}.0/24"

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "worker-${count.index}"
  }
}

