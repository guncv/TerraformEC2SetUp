resource "tls_private_key" "my_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "MyTerraformKey"
  public_key = tls_private_key.my_ssh_key.public_key_openssh
}