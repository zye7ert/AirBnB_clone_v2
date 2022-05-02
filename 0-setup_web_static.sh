#!/usr/bin/env bash
## Run sudo update.
sudo apt-get -y update
## Install nginx.
sudo apt-get -y install nginx
## Change User /var/www
sudo chown -R ubuntu /var/www
## Change file default --> index.html to nginx.
echo "Hello World!" > /var/www/html/index.nginx-debian.html
## Create file error --> error_404.html to nginx.
echo "Ceci n'est pas une page" > /var/www/html/error_404.html
## sets up your web servers for the deployment of web_static. It must:
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/
## sudo chown $USER:$USER /data/
sudo chown -R ubuntu:ubuntu /data/
## Create file index --> index.html to /data/web_static/releases/test/.
echo "Holberton School" > /data/web_static/releases/test/index.html
## line copy data path 1 --> path 2
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
## Redirecting to another page (The redirection must be a “301 Moved Permanently”)
sudo sed -i "s/server_name _;/server_name _;\n\trewrite ^\/redirect_me https:\/\/www.youtube.com\/watch?v=NdYWuo9OFAw permanent;/" /etc/nginx/sites-available/default
## Redirecting to another page (The page must return an HTTP 404 error code)
sudo sed -i "s/^server\s{/server {\n\terror_page 404 \/error_404.html;/1" /etc/nginx/sites-available/default
## Change name server
sudo sed -i "s/^server\s{/server {\n\tadd_header X-Served-By $HOSTNAME;/1" /etc/nginx/sites-available/default
## adding line into location /etc/nginx/sites-available/default
sudo sed -i "/listen 80 default_server;/ a \\\n\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n" /etc/nginx/sites-available/default
## Restart service nginx
sudo service nginx restart
