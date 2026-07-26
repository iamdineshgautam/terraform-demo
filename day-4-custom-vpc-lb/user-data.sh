#!/bin/bash
sudo dnf update -y
sudo dnf install nginx -y
sudo systemctl enable nginx 
sudo systemctl start nginx
echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html