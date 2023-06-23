resource "tls_private_key" "kubernetes" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "kubernetes_private_key" {
  filename  = "kubernetes.id_rsa"
  content   = tls_private_key.kubernetes.private_key_pem
}


resource "aws_key_pair" "kubernetes" {
  key_name   = "kubernetes"
  public_key = tls_private_key.kubernetes.public_key_openssh
}
