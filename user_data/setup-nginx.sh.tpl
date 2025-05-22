#!/bin/bash
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx
sudo mkdir -p /var/www/html/
echo "ok" | sudo touch healthcheck | sudo tee /var/www/html/healthcheck
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo vi /etc/nginx/nginx.conf
location / {
        proxy_pass http://internal_alb_DNS_name;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;                                                                                                            
    }         


