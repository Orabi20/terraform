resource "aws_instance" "proxy" {
  count                  = length(var.public_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnet_ids, count.index)
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  user_data              = <<-EOF
                           #!/bin/bash
                           sudo yum update -y 
                           sudo yum install -y nginx
                           sudo amazon-linux-extras install nginx1 -y
                           sudo systemctl enable --now nginx
                           sudo systemctl start nginx
                           EOF
  tags = {
    Name = "proxy-${count.index + 1}"
  }

}
resource "aws_instance" "backend" {
  count                  = length(var.private_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.private_subnet_ids, count.index)
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo yum update -y
                            sudo yum install -y httpd
                            sudo systemctl start httpd
                            sudo systemctl enable httpd
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
                            <h1>Hello from Backend</h1>
                            <p>by Ahmed Orabi</p>
                            </body>
                            </html>
                            " > /var/www/html/index.html

                            EOF
  tags = {
    Name = "backend-${count.index + 1}"
  }
}
