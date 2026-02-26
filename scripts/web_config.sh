#!/bin/bash

apt-get update

# set up a web server
apt-get install -y nginx
echo "<h1>Witaj na serwerze: $HOSTNAME</h1>" > /var/www/html/index.html

# start the service
systemctl enable nginx
systemctl start nginx 