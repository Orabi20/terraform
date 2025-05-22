module "vpc" {
  source   = "C:/Users/Ahmed Orabi/Desktop/terraform-lab/modules/vpc"
  vpc_cidr = var.vpc_cidr
}
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "main-igw"
  }
}

module "subnets" {
  source             = "C:/Users/Ahmed Orabi/Desktop/terraform-lab/modules/subnets"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = module.subnets.public_subnet_ids[0]
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "nat"
  }
}
resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(module.subnets.private_subnet_ids, count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table" "public_rt" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(module.subnets.public_subnet_ids)
  subnet_id      = element(module.subnets.public_subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt.id
}

module "security_groups" {
  source = "C:/Users/Ahmed Orabi/Desktop/terraform-lab/modules/security_groups"
  vpc_id = module.vpc.vpc_id

}
module "ec2" {
  source             = "C:/Users/Ahmed Orabi/Desktop/terraform-lab/modules/ec2"
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  sg_id              = module.security_groups.ec2_sg_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  ami_id             = var.ami_id
  private_key_path   = var.private_key_path

}
module "alb" {
  source               = "C:/Users/Ahmed Orabi/Desktop/terraform-lab/modules/alb"
  state                = var.states
  vpc_id               = module.vpc.vpc_id
  subnet_ids1          = module.subnets.public_subnet_ids
  subnet_ids2          = module.subnets.private_subnet_ids
  target_instance_ids1 = module.ec2.proxy_instance_ids
  target_instance_ids2 = module.ec2.backend_instance_ids
  sg_id                = module.security_groups.alb_sg_id
}

# resource "local_file" "all_server_ips" {
#   content  = join("\n", concat(module.ec2.proxy_public_ips, module.ec2.backend_private_ips))
#   filename = "all_server_ips.txt"
# }

