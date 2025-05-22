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

############################################################################################

echo "<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hello from Backend1</title>
  <style>
    body {
      background: linear-gradient(to right, #1e3c72, #2a5298);
      color: white;
      font-family: 'Segoe UI', sans-serif;
      text-align: center;
      padding-top: 20%;
    }
    h1 {
      font-size: 3em;
      color: #ffcc00;
      text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
    }
    p {
      font-size: 1.5em;
      color: #ffffff;
    }
  </style>
</head>
<body>
  <h1>Hello from Backend1</h1>
  <p>by Ahmed Orabi</p>
</body>
</html>
" > /var/www/html/index.html