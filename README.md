📦 Terraform AWS Infrastructure Lab
This project builds a complete modular AWS infrastructure using Terraform. It simulates a real-world, secure architecture where a public-facing ALB routes traffic through reverse proxy EC2 instances (NGINX) to Apache servers hosted in private subnets.

🔧 Features
🧱 Fully modularized Terraform code

☁️ VPC with public/private subnets across 2 AZs

🔐 Security Groups for ALB, EC2, and Apache layers

🌐 Public ALB → NGINX reverse proxies (public EC2) → Apache (private EC2)

🔄 Private ALB between proxies and Apache servers

📁 Remote backend using S3 and DynamoDB for state locking

🧪 Health checks for all ALBs

📜 Local file output of all EC2 private/public IPs

🔄 Provisioning with remote-exec to install & configure NGINX/Apache

🛡️ Minimal hardcoding — fully variable-driven

🗂️ Project Structure
bash
Copy
Edit
terraform-lab/
├── main.tf
├── variables.tf
├── backend.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── security_groups/
│   ├── alb/
│   ├── ec2/
├── user_data/
│   └──  setup-nginx.sh.tpl  
└── README.md
🏗️ Architecture Diagram
less
Copy
Edit
                    [ Public ALB ]
                          |
                ---------------------
                |                   |
        [ Reverse Proxy EC2 ]   [ Reverse Proxy EC2 ]
                |                   |
                ---------------------
                          |
                    [ Private ALB ]
                          |
                ---------------------
                |                   |
        [ Apache EC2 (private) ] [ Apache EC2 (private) ]
🚀 Usage
1. Initialize Terraform
bash
Copy
Edit
terraform init
2. Apply Configuration
bash
Copy
Edit
terraform apply -auto-approve
💡 Make sure your terraform.tfvars is populated with region, VPC CIDRs, key pair path, etc.

3. Access
Access the public ALB DNS in a browser → you'll be routed through NGINX to Apache.

ALB health checks ensure NGINX and Apache layers are responsive.

🔐 Prerequisites
AWS CLI configured

A valid AWS Key Pair

Terraform v1.3+

🧼 Cleanup
bash
Copy
Edit
terraform destroy
✍️ Author
Ahmed Orabi
💼 DevOps | Cloud Engineer | Infrastructure as Code
