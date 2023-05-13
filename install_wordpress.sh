#!/bin/bash

# Update packages
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Start Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Install PHP and necessary modules
sudo amazon-linux-extras install -y php7.4
sudo yum install -y php-{mbstring,gd,xml,zip}

# Restart Apache
sudo systemctl restart httpd

# Download and configure WordPress
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rm -rf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress
sudo chown -R apache:apache /var/www/html

# Configure WordPress database settings
cp wp-config-sample.php wp-config.php
sed -i "s/database_name/database_name/" wp-config.php
sed -i "s/username/username/" wp-config.php
sed -i "s/password/password/" wp-config.php

# Allow WordPress to write files
sudo chmod -R 755 /var/www/html/wp-content/uploads

# Restart Apache
sudo systemctl restart httpd
