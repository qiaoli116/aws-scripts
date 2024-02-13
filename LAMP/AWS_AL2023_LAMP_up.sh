#!/bin/bash

# Step 1: Prepare the LAMP server

# Update packages
sudo dnf update -y

# Install Apache, PHP, and MariaDB
sudo dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel mariadb105-server

# Start Apache
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Add rule to allow inbound HTTP traffic
# (Assuming default security group with SSH already configured)
# Add HTTP rule if not present
# aws ec2 authorize-security-group-ingress --group-name <your-security-group-name> --protocol tcp --port 80 --cidr 0.0.0.0/0

# Verify Apache is enabled
sudo systemctl is-enabled httpd

# Set permissions for Apache
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

# Step 2: Test your LAMP server
# (Optional) Create a PHP file in the Apache document root to test PHP
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# Step 3: Secure the MariaDB server
sudo systemctl start mariadb
sudo mysql_secure_installation

# Step 4: (Optional) Install phpMyAdmin
# Install dependencies
sudo dnf install php-mbstring php-xml -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm

# Download and extract phpMyAdmin
cd /var/www/html
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz

# Start MySQL if not running
sudo systemctl start mariadb

# Clean up
rm /var/www/html/phpinfo.php

# Done
echo "LAMP stack setup complete!"
