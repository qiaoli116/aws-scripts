#!/bin/bash

# Step 1: Remove Apache, PHP, and MariaDB

# Stop Apache
sudo systemctl stop httpd

# Disable Apache from starting on boot
sudo systemctl disable httpd

# Uninstall Apache, PHP, and MariaDB
sudo dnf remove -y httpd wget php-fpm php-mysqli php-json php php-devel mariadb105-server

# Step 2: Remove phpMyAdmin (if installed)

# Stop MySQL
sudo systemctl stop mariadb

# Uninstall phpMyAdmin
sudo rm -rf /var/www/html/phpMyAdmin

# Step 3: Clean up permissions

# Remove ec2-user from the apache group
sudo deluser ec2-user apache

# Reset permissions for /var/www
sudo chown -R root:root /var/www
sudo chmod 755 /var/www && find /var/www -type d -exec sudo chmod 755 {} \;
find /var/www -type f -exec sudo chmod 644 {} \;

# Step 4: Reset MariaDB (if secured)

# Reset MariaDB
sudo systemctl start mariadb
sudo mysql_secure_installation

# Done
echo "Cleanup complete! LAMP stack has been removed."
