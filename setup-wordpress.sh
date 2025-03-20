#!/bin/bash
set -ex  # Enable debugging and stop script on errors

# ✅ Log File Location
LOG_FILE="/var/log/user_data.log"
exec > >(tee -a "$LOG_FILE" /var/log/cloud-init-output.log) 2>&1

echo "🚀 Starting User Data Script..."


mkdir -p /home/ubuntu/.ssh
echo "${private_key}" > /home/ubuntu/.ssh/mariadb_key.pem
chmod 400 /home/ubuntu/.ssh/mariadb_key.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/mariadb_key.pem

echo "${TA_SSH_KEY}" > /home/ubuntu/.ssh/authorized_keys.pem
chmod 400 /home/ubuntu/.ssh/authorized_keys.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys.pem

# ✅ Update and Install Required Packages
echo "🔹 Updating system..."
apt update -y
echo "🔹 Installing required packages..."
sudo apt install -y apache2 php8.3 php8.3-fpm php8.3-mysql php8.3-opcache libapache2-mod-php8.3 php8.3-cli php8.3-common php8.3-xml php8.3-mbstring php8.3-curl php8.3-gd mysql-client unzip curl wget || { echo "❌ Failed to install required packages!"; exit 1; }

# ✅ Install AWS CLI
echo "🔹 Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    apt install unzip -y
    unzip awscliv2.zip
    ./aws/install
aws --version || { echo "❌ AWS CLI installation failed!"; exit 1; }

# ✅ Install WP-CLI
if ! command -v wp &> /dev/null; then
    echo "🔹 Installing WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi
sudo -u www-data wp --version || { echo "❌ WP-CLI installation failed!"; exit 1; }

# ✅ Install WordPress
echo "🔹 Downloading WordPress..."
wget -q --tries=3 --timeout=20 https://wordpress.org/latest.zip -O latest.zip || { echo "❌ Failed to download WordPress!"; exit 1; }
unzip -q latest.zip
cp -r wordpress/* /var/www/html/

# ✅ Set Correct Permissions
echo "🔹 Setting WordPress permissions..."
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# ✅ Configure wp-config.php
echo "🔹 Configuring wp-config.php..."
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/g" /var/www/html/wp-config.php
sed -i "s/username_here/${DB_USER}/g" /var/www/html/wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/g" /var/www/html/wp-config.php
sed -i "s/localhost/${DB_HOST}/g" /var/www/html/wp-config.php

# ✅ Secure wp-config.php
echo "🔹 Securing wp-config.php..."
chown www-data:www-data /var/www/html/wp-config.php
chmod 600 /var/www/html/wp-config.php

# ✅ Restart Apache
echo "🔹 Restarting Apache..."
systemctl restart apache2 || { echo "❌ Apache failed to restart!"; exit 1; }

# ✅ Get Public IP
echo "🔹 Fetching public IP..."
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PUBLIC_IP=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/public-ipv4") || { echo "❌ Failed to get public IP!"; exit 1; }
echo "Instance Public IP: $PUBLIC_IP" > /home/ubuntu/public_ip.txt

# ✅ Check IAM Role and AWS Credentials
echo "🔹 Checking IAM Role and AWS Credentials..."
aws sts get-caller-identity || { echo "❌ EC2 instance does not have IAM permissions!"; exit 1; }

echo "🔹 Modifying access permissions for /var/www/html..."
chown -R www-data:www-data /var/www/html/
chmod -R 775 /var/www/html/ || { echo "❌ Failed to modify access permissions!"; exit 1; }

# ✅ Verify S3 Bucket Access Before Plugin Installation
echo "🔹 Checking if S3 bucket exists..."
aws s3api head-bucket --bucket "${BUCKET_NAME}" || { echo "❌ S3 bucket does not exist or is not accessible!"; exit 1; }

# ✅ Install & Configure WordPress
echo "🔹 Running WP-CLI to install WordPress as www-data..."
sudo -u www-data wp core install --url="http://$PUBLIC_IP" --admin_user="${ADMIN_USER}" --admin_password="${ADMIN_PASSWORD}" --admin_email="example@example.com" --title="${TITLE}" --skip-email --path=/var/www/html/ || { echo "❌ WordPress installation failed!"; exit 1; }

# ✅ Ensure WP-CLI cache directory exists
echo "🔹 Ensuring WP-CLI cache directory permissions..."
mkdir -p /var/www/.wp-cli/cache
chown -R www-data:www-data /var/www/.wp-cli
chmod -R 755 /var/www/.wp-cli

# ✅ Install Amazon S3 Plugin
echo "🔹 Installing Amazon S3 plugin as www-data..."
sudo -u www-data wp plugin install amazon-s3-and-cloudfront --activate --path=/var/www/html || { echo "❌ Plugin installation failed!"; exit 1; }

# ✅ Remove Local Uploads Directory (Force S3)
echo "🔹 Removing local wp-content/uploads directory to force S3 usage..."
rm -rf /var/www/html/wp-content/uploads/

echo "🔹 Setting correct permissions for wp-config.php..."
sudo chown www-data:www-data /var/www/html/wp-config.php
sudo chmod 775 /var/www/html/wp-config.php

# ✅ Configure WordPress to Use S3
echo "🔹 Configuring WordPress to use S3..."
if grep -q "AS3CF_SETTINGS" /var/www/html/wp-config.php; then
    echo "✅ S3 settings already exist in wp-config.php. Skipping..."
else
    echo "✅ Adding S3 settings above 'Happy publishing' in wp-config.php..."
    # Insert S3 settings above "Happy publishing"
    sudo sed -i "/Happy publishing/i \\
\\n// ✅ Amazon S3 Offload Media Plugin Configuration\\n\
define('AS3CF_SETTINGS', serialize(array(\\n\
    'provider' => 'aws',\\n\
    'bucket' => '${BUCKET_NAME}',\\n\
    'region' => '${REGION}',\\n\
    'use-server-roles' => true,\\n\
    'copy-to-s3' => true,\\n\
    'serve-from-s3' => true\\n\
)));\\n" /var/www/html/wp-config.php
fi

echo "🔹 Deactivating Amazon S3 plugin..."
sudo -u www-data wp plugin deactivate amazon-s3-and-cloudfront --allow-root --path=/var/www/html

echo "🔹 Activating Amazon S3 plugin..."
sudo -u www-data wp plugin activate amazon-s3-and-cloudfront --allow-root --path=/var/www/html


echo "🔹 Setting correct permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 775 /var/www/html/

# ✅ Apply S3 Plugin Settings
echo "🔹 Applying Amazon S3 plugin settings as www-data..."
sudo -u www-data wp option update as3cf_settings --format=json --path=/var/www/html/ <<EOT
{
    "provider": "aws",
    "bucket": "${BUCKET_NAME}",
    "region": "${REGION}",
    "use-server-roles": true,
    "copy-to-s3": true,
    "serve-from-s3": true
}
EOT

# ✅ Verify S3 Configuration
echo "🔹 Verifying S3 connection..."
sudo -u www-data wp option get as3cf_settings --path=/var/www/html/

# ✅ Upload Test File to S3
echo "🔹 Uploading test file to S3..."
echo "Test file for S3 upload verification" > /var/www/html/test-upload.txt

if aws s3 cp /var/www/html/test-upload.txt "s3://${BUCKET_NAME}/test-upload.txt"; then
    echo "✅ Test file successfully uploaded to S3!"
else
    echo "❌ Test upload to S3 failed!" | tee -a /var/log/user-data.log
    exit 1
fi

# ✅ Configure WordPress to use S3 for uploads
echo "🔹 Configuring WordPress to use S3 for uploads..."
sudo -u www-data wp option update upload_url_path "https://${BUCKET_NAME}.s3.${REGION}.amazonaws.com" --path=/var/www/html
echo "🔹 Replacing media URLs using dynamic WordPress public IP..."
sudo -u www-data wp search-replace "http://$PUBLIC_IP/wp-content/uploads/" \
    "https://${BUCKET_NAME}.s3.${REGION}.amazonaws.com/" --skip-columns=guid --path=/var/www/html

echo "🔹 Uploading test file to S3..."
echo "Test file for S3 upload verification" > /var/www/html/test-upload.txt

if aws s3 cp /var/www/html/test-upload.txt "s3://${BUCKET_NAME}/test-upload.txt"; then
    echo "✅ Test file uploaded! Verifying existence..."
    if aws s3 ls "s3://${BUCKET_NAME}/test-upload.txt"; then
        echo "✅ Test file exists in S3!"
    else
        echo "❌ Test file not found in S3!"
        exit 1
    fi
else
    echo "❌ Test upload to S3 failed!" | tee -a /var/log/user-data.log
    exit 1
fi

# Restart Apache **only once**
echo "🔹 Restarting Apache..."
sudo systemctl restart apache2
echo "WordPress & S3 Setup Completed Successfully!" | tee -a /var/log/user-data.log

# Display Elastic IP after completion
echo "🔹 Displaying Elastic IP after completion..."
echo "Elastic IP of WordPress Instance: http://$PUBLIC_IP" | tee -a /var/log/user-data.log

# ✅ List Installed Plugins
echo "🔹 Listing installed plugins..."
sudo -u www-data wp plugin list --path=/var/www/html/

echo "✅ WordPress & Plugin setup complete!"
