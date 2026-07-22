#!bin/bash
sudo apt update
sudo apt install httpd
sudo systemctl enable httpd.service
sudo systemctl start httpd.service
sudo echo "<h1> Welcome to terraform </h1>" > /var/www/html/index.html
