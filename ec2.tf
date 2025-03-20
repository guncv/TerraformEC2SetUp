resource "aws_instance" "wordpress" {
  ami                  = var.ami_id
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.terraform_key.key_name
  iam_instance_profile = aws_iam_instance_profile.wordpress_instance_profile.name 

  depends_on = [
    aws_instance.mariadb,
    aws_iam_instance_profile.wordpress_instance_profile
  ]

  network_interface {
    network_interface_id = aws_network_interface.wordpress_public.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.wordpress_private.id
    device_index         = 1
  }


  user_data = templatefile("setup-wordpress.sh", {
    TA_SSH_KEY  = var.TA_SSH_KEY
    private_key = tls_private_key.my_ssh_key.private_key_pem
    DB_HOST     = aws_network_interface.mariadb_nat.private_ip
    DB_NAME     = var.wordpress_db_name
    DB_USER     = var.wordpress_db_user
    DB_PASSWORD = var.wordpress_db_password
    BUCKET_NAME = var.bucket_name
    REGION      = var.aws_region
    ADMIN_USER  = var.wordpress_db_user
    ADMIN_PASSWORD = var.wordpress_db_password
    TITLE       = var.wordpress_title
  })

  tags = {
    Name = var.wordpress_instance_name
  }
}

resource "aws_instance" "mariadb" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.mariadb_private.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.mariadb_nat.id
    device_index         = 1
  }

  user_data = templatefile("setup-mariadb.sh", {
    TA_SSH_KEY   = var.TA_SSH_KEY
    DB_USER      = var.wordpress_db_user
    DB_PASSWORD  = var.wordpress_db_password
    DB_NAME      = var.wordpress_db_name
  })

  tags = {
    Name = var.mariadb_instance_name
  }
}
