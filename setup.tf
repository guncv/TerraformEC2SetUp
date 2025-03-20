# resource "null_resource" "wordpress_setup" {
#   depends_on = [aws_instance.wordpress, aws_instance.mariadb, aws_eip.wordpress_eip]

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       host        = aws_eip.wordpress_eip.public_ip
#       private_key = tls_private_key.my_ssh_key.private_key_pem
#     }

#     inline = [
#       "sudo apt update -y",
#       "sudo apt install -y apache2 php8.3 php8.3-mysql libapache2-mod-php mariadb-client unzip wget curl",

#       # Download and install WordPress
#       "wget https://wordpress.org/latest.zip",
#       "unzip latest.zip",
#       "sudo cp -r wordpress/* /var/www/html/",
#       "sudo chown -R www-data:www-data /var/www/html/",
#       "sudo chmod -R 755 /var/www/html/",

#       # Configure wp-config.php
#       "sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php",
#       "sudo sed -i \"s/database_name_here/${var.wordpress_db_name}/g\" /var/www/html/wp-config.php",
#       "sudo sed -i \"s/username_here/${var.wordpress_db_user}/g\" /var/www/html/wp-config.php",
#       "sudo sed -i \"s/password_here/${var.wordpress_db_password}/g\" /var/www/html/wp-config.php",
#       "sudo sed -i \"s/localhost/${aws_instance.mariadb.private_ip}/g\" /var/www/html/wp-config.php",
#       "sudo chown www-data:www-data /var/www/html/wp-config.php",
#       "sudo chmod 644 /var/www/html/wp-config.php",

#       # Restart Apache
#       "sudo systemctl restart apache2",

#       # Install WP-CLI
#       "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
#       "chmod +x wp-cli.phar",
#       "sudo mv wp-cli.phar /usr/local/bin/wp",

#       # Install and configure WordPress
#       "sudo -u www-data wp core install --allow-root --path=/var/www/html --url=http://${aws_eip.wordpress_eip.public_ip} --title='${var.wordpress_title}' --admin_user=${var.wordpress_admin_user} --admin_password=${var.wordpress_admin_password} --admin_email=${var.wordpress_admin_email}",

#       # Ensure uploads folder exists
#       "sudo mkdir -p /var/www/html/wp-content/uploads",
#       "sudo chown -R www-data:www-data /var/www/html/",
#       "sudo find /var/www/html -type f -exec chmod 644 {} \\;",

#       # Install and configure WP Offload Media plugin
#       "sudo -u www-data wp plugin install amazon-s3-and-cloudfront --activate --allow-root --path=/var/www/html",

#       # Restart services
#       "sudo systemctl restart apache2",

#       # Reactivate plugin to apply config
#       "sudo -u www-data wp plugin deactivate amazon-s3-and-cloudfront --allow-root --path=/var/www/html",
#       "sudo -u www-data wp plugin activate amazon-s3-and-cloudfront --allow-root --path=/var/www/html",

#       # Final permission fix
#       "sudo chmod -R 755 /var/www/html/"
#     ]
#   }

#   # ✅ Fixed: Move the multi-line command outside of inline list
#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       host        = aws_eip.wordpress_eip.public_ip
#       private_key = tls_private_key.my_ssh_key.private_key_pem
#     }

#     inline = [
#       <<EOF
#       sudo bash -c 'cat >> /var/www/html/wp-config.php <<EOT
#       define("AS3CF_SETTINGS", serialize([
#           "provider"           => "aws",
#           "bucket"             => "${var.bucket_name}",
#           "region"             => "${var.aws_region}",
#           "copy-to-s3"         => true,
#           "serve-from-s3"      => true,
#           "remove-local-file"  => false,
#           "use-yearmonth-folders" => true,
#           "object-prefix"      => "wp-content/uploads/",
#           "force-https"        => false,
#           "bucket-access"      => "public",
#           "domain-type"        => "path",
#       ]));

#       if (!defined("ABSPATH")) {
#           define("ABSPATH", __DIR__ . "/");
#       }

#       require_once ABSPATH . "wp-settings.php";
#       EOT'
#       EOF
#     ]
#   }
# }
