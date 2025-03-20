resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.wordpress_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [
    aws_route_table.private_rt.id,
    aws_route_table.public_rt.id
  ]

  tags = {
    Name = var.vpc_endpoint_name
  }
}
