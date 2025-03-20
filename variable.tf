variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Availability zone within the AWS region"
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-0672fd5b9210aa093"  
}


variable "bucket_name" {
  description = "Name of the S3 bucket for WordPress media storage"
  default     = "6431309721-wordpressmidterm-bucket"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  default     = "WordPressMidterm-VPC"
}

variable "public_subnet_name" {
  description = "Name tag for the Public Subnet"
  default     = "WordPressMidterm-Public-Subnet"
}

variable "private_subnet_name" {
  description = "Name tag for the Private Subnet"
  default     = "WordPressMidterm-Private-Subnet"
}

variable "internet_gateway_name" {
  description = "Name tag for the Internet Gateway"
  default     = "WordPressMidterm-IGW"
}

variable "wordpress_server_name" {
  description = "Name tag for the WordPress EC2 instance"
  default     = "WordPressMidterm-Server"
}

variable "mariadb_server_name" {
  description = "Name tag for the MariaDB EC2 instance"
  default     = "MariaDBMidterm-Server"
}

variable "public_ip" {
  description = "Your public IP address for SSH access"
  default     = "184.22.105.175/32"  
}

variable "wordpress_instance_name" {
  description = "Name tag for the WordPress EC2 instance"
  default     = "WordPressMidterm-Instance"
}

variable "mariadb_instance_name" {
  description = "Name tag for the MariaDB EC2 instance"
  default     = "MariaDBMidterm-Instance"
}

variable "wordpress_sg_name" {
  description = "Name tag for the WordPress security group"
  default     = "WordPressMidterm-Security-Group"
}

variable "mariadb_sg_name" {
  description = "Name tag for the MariaDB security group"
  default     = "MariaDBMidterm-Security-Group"
}

variable "private_rt_name" {
  description = "Name tag for the Private Route Table"
  default     = "WordPressMidterm-Private-Route-Table"
}

variable "nat_gateway_name" {
  description = "Name tag for the NAT Gateway"
  default     = "WordPressMidterm-NAT-Gateway"
}

variable "vpc_endpoint_name" {
  description = "Name tag for the VPC Endpoint"
  default     = "WordPressMidterm-VPC-Endpoint"
}

variable "public_rt_name" {
  description = "Name tag for the Public Route Table"
  default     = "WordPressMidterm-Public-Route-Table"
}

variable "wordpress_db_name" {
  description = "Name of the WordPress database"
  default     = "wordpress"
}

variable "wordpress_db_user" {
  description = "Name of the WordPress database user"
  default     = "root"
}

variable "wordpress_db_password" {
  description = "Password for the WordPress database user"
  default     = "password"
}

variable "wordpress_s3_user_name" {
  description = "Name of the IAM user for WordPress S3 access"
  default     = "WordPressS3User"
}

variable "wordpress_s3_policy_name" {
  description = "Name of the IAM policy for WordPress S3 access"
  default     = "WordPressS3Policy"
}

variable "wordpress_iam_role_name" {
  description = "Name of the IAM role for WordPress"
  default     = "WordPressIAMRole"
}

variable "wordpress_instance_profile_name" {
  description = "Name of the IAM instance profile for WordPress"
  default     = "WordPressInstanceProfile"
}

variable "wordpress_ec2_role_name" {
  description = "Name of the IAM role for WordPress"
  default     = "WordPressIAMRole"
}

variable "s3_access_policy_name" {
  description = "Name of the IAM policy for WordPress S3 access"
  default     = "WordPressS3Policy"
}

variable "wordpress_title" {
  description = "Title for the WordPress site"
  default     = "Chanagun"
}

variable "wordpress_admin_user" {
  description = "Username for the WordPress admin user"
  default     = "admin"
}

variable "wordpress_admin_password" {
  description = "Password for the WordPress admin user"
  default     = "password"
}

variable "TA_SSH_KEY" {
  description = "SSH key for the Terraform user"  
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODaHqtrCOBpfD+meWggDG5gFEqnNDtpxnqQ7 xWIfXfL cloud-wordpress"
}

variable "private_nat_subnet_name" {
  description = "Name tag for the Private NAT Subnet"
  default     = "WordPressMidterm-Private-NAT-Subnet"
}

variable "private_nat_subnet_cidr" {
  description = "CIDR block for the Private NAT Subnet"
  default     = "10.0.3.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the Public Subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the Private Subnet"
  default     = "10.0.2.0/24"
}

variable "wordpress_public_interface_name" {
  description = "Name tag for the WordPress public interface"
  default     = "WordPressPublicInterface"
}

variable "wordpress_private_interface_name" {
  description = "Name tag for the WordPress private interface"
  default     = "WordPressPrivateInterface"
}

variable "mariadb_private_interface_name" {
  description = "Name tag for the MariaDB private interface"
  default     = "MariaDBPrivateInterface"
}

variable "mariadb_nat_interface_name" {
  description = "Name tag for the MariaDB NAT interface"
  default     = "MariaDBNATInterface"
}
























