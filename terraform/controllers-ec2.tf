resource "aws_instance" "controller" {
  count                       = 3
  ami                         = "ami-0f8e81a3da6e2510a"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  key_name                    = "kubernetes"
  private_ip                  = "10.0.1.1${count.index}"

  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]

  tags = {
    Name = "controller-${count.index}"
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
  }

  user_data = <<-EOF
  #!/bin/bash
  echo "name=controller-${count.index}" > /etc/environment
  EOF

  disable_api_termination = false
  source_dest_check       = false
}

