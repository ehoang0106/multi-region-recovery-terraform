#!/bin/bash
yum install -y httpd
echo "<h1>Web Server 2 - US East</h1>" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd