resource "aws_network_interface" "mariadb_private" {
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.mariadb_sg.id]
  tags = { Name = var.mariadb_private_interface_name }
}

resource "aws_network_interface" "mariadb_nat" {
  subnet_id       = aws_subnet.private_nat_subnet.id
  security_groups = [aws_security_group.mariadb_sg.id]
  tags = { Name = var.mariadb_nat_interface_name }
}

resource "aws_network_interface" "wordpress_public" {
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.wordpress_sg.id]
  tags = { Name = var.wordpress_public_interface_name }
}

resource "aws_network_interface" "wordpress_private" {
  subnet_id       = aws_subnet.private_nat_subnet.id
  security_groups = [aws_security_group.wordpress_sg.id]
  tags = { Name = var.wordpress_private_interface_name }
}