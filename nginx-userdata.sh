#!/bin/bash

sudo yum update -y && 
sudo amazon-linux-extras install -y nginx1
sudo sudo usermod -aG nginx ec2-user && sudo chown -R ec2-user:nginx /usr/share/nginx && 
sudo chmod 2775 /usr/share/nginx && find /usr/share/nginx -type d -exec sudo chmod 2775 {} \;
find /usr/share/nginx -type f -exec sudo chmod 0664 {} \;
echo "<h1>It's Alive and running from $(hostname -f)<h/1>" > /usr/share/nginx/html/index.html
sudo systemctl start nginx && sudo systemctl enable nginx


