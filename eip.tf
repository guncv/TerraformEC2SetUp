resource "aws_eip" "wordpress_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "wordpress_eip_assoc" {
  network_interface_id = aws_network_interface.wordpress_public.id
  allocation_id        = aws_eip.wordpress_eip.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = { Name = var.nat_gateway_name }
}