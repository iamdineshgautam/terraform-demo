#!/bin/bash
sudo dnf update -y
sudo dnf install httpd -y
sudo systemctl start httpd.service 
sudo echo "<h1> Welcome to terraform of $HOSTNAME </h1>" > /var/www/html/index.html
sudo systemctl reload httpd.service 