#!/bin/bash
yum install -y httpd
echo "<h1>Web Server</h1>" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd