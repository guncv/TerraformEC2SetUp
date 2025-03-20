# output "wordpress_instance_ip" {
#   description = "WordPress instance IP (should match the URL)"
#   value       = aws_instance.wordpress.public_ip
# }

output "wordpress_elastic_ip" {
  description = "Elastic IP assigned to the WordPress instance"
  value       = aws_eip.wordpress_eip.public_ip
}

output "cidr_public_subnet_app_inet" {
  description = "CIDR of the public subnet for App-Inet"
  value       = aws_subnet.public_subnet.cidr_block
}

output "cidr_private_subnet_app_db" {
  description = "CIDR of the private subnet for App-DB"
  value       = aws_subnet.private_subnet.cidr_block
}

output "cidr_private_subnet_db_inet" {
  description = "CIDR of the private subnet for DB-Inet"
  value       = aws_subnet.private_nat_subnet.cidr_block
}

output "db_instance_no_public_ip" {
  description = "Database instance does not have a public IP"
  value       = aws_instance.mariadb.public_ip
}

output "s3_upload_verification" {
  description = "Verify file upload by checking the S3 bucket URL"
  value       = "Go to AWS S3 Console and check the bucket: ${aws_s3_bucket.wordpress_s3.bucket}"
}

