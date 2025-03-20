#!/bin/bash
MARIADB_CONF="/etc/mysql/mariadb.conf.d/50-server.cnf"
LOG_FILE="/var/log/mariadb_setup.log"

exec > >(tee -a "$LOG_FILE") 2>&1

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y software-properties-common gnupg2 curl

curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash
sudo apt update -y
sudo apt install -y mariadb-server mariadb-client

echo "${TA_SSH_KEY}" > /home/ubuntu/.ssh/authorized_keys.pem
chmod 400 /home/ubuntu/.ssh/authorized_keys.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys.pem

sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" "$MARIADB_CONF"
sudo systemctl restart mariadb

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "FLUSH PRIVILEGES;"

DB_EXISTS=$(sudo mysql -u root -p"${DB_PASSWORD}" -e "SHOW DATABASES LIKE '${DB_NAME}';" | grep "${DB_NAME}" > /dev/null; echo "$?")
if [ "$DB_EXISTS" -ne 0 ]; then
    sudo mysql -u root -p"${DB_PASSWORD}" -e "CREATE DATABASE ${DB_NAME};"
fi

USER_EXISTS=$(sudo mysql -u root -p"${DB_PASSWORD}" -e "SELECT User FROM mysql.user WHERE User='${DB_USER}' AND Host='%';" | grep "${DB_USER}" > /dev/null; echo "$?")
if [ "$USER_EXISTS" -ne 0 ]; then
    sudo mysql -u root -p"${DB_PASSWORD}" -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
fi

sudo mysql -u root -p"${DB_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;"
sudo mysql -u root -p"${DB_PASSWORD}" -e "FLUSH PRIVILEGES;"
sudo systemctl restart mariadb

mariadb --version
