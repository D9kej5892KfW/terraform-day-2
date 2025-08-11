# Phase 2: Custom VPC - Taking Control of Your Network
# This shows why custom VPCs are better than the default VPC

# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# CUSTOM VPC - Your own private cloud network
# This is YOUR network, designed by YOU, managed by Terraform
resource "aws_vpc" "learning_vpc" {
  cidr_block           = "10.0.0.0/16"    # Your private IP address space
  enable_dns_hostnames = true              # Allow DNS names for instances
  enable_dns_support   = true              # Enable DNS resolution
  
  tags = {
    Name        = "Learning VPC"
    Purpose     = "Terraform Networking Learning"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# PUBLIC SUBNET - For resources that need internet access
# This will hold web servers, load balancers, etc.
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.learning_vpc.id
  cidr_block              = "10.0.1.0/24"           # 256 IP addresses
  availability_zone       = "us-east-1a"            # Specific AZ
  map_public_ip_on_launch = true                    # Auto-assign public IPs
  
  tags = {
    Name = "Public Subnet"
    Type = "Public"
  }
}

# PRIVATE SUBNET - For resources that should NOT have direct internet access
# This will hold databases, internal services, etc.
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.learning_vpc.id
  cidr_block        = "10.0.2.0/24"           # 256 IP addresses
  availability_zone = "us-east-1b"            # Different AZ for redundancy
  # Note: No map_public_ip_on_launch - private by design!
  
  tags = {
    Name = "Private Subnet"
    Type = "Private"
  }
}

# INTERNET GATEWAY - The door to the internet
# Without this, your VPC is completely isolated
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.learning_vpc.id
  
  tags = {
    Name = "Learning VPC Internet Gateway"
  }
}

# ROUTE TABLE - Tells traffic where to go
# This is for PUBLIC subnet - routes internet traffic to the IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.learning_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"                    # All internet traffic
    gateway_id = aws_internet_gateway.igw.id    # Goes through IGW
  }
  
  tags = {
    Name = "Public Route Table"
  }
}

# ROUTE TABLE ASSOCIATION - Connect subnet to route table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# SECURITY GROUP - Instance-level firewall
# This acts like a firewall for individual EC2 instances
resource "aws_security_group" "web_sg" {
  name_prefix = "web-server-sg"
  vpc_id      = aws_vpc.learning_vpc.id
  description = "Security group for web servers"
  
  # INBOUND RULES (Ingress) - What traffic can come IN to your instances
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere on internet
  }
  
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere on internet
  }
  
  ingress {
    description = "SSH from your network only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Only allow SSH from within VPC
  }
  
  # OUTBOUND RULES (Egress) - What traffic can go OUT from your instances
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow to anywhere
  }
  
  tags = {
    Name = "Web Server Security Group"
    Type = "Web"
  }
}

# SECURITY GROUP for Database servers
# This shows how to create more restrictive rules
resource "aws_security_group" "db_sg" {
  name_prefix = "database-sg"
  vpc_id      = aws_vpc.learning_vpc.id
  description = "Security group for database servers"
  
  # INBOUND RULES - Only allow database traffic from web servers
  ingress {
    description     = "MySQL/Aurora from web servers only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]  # Only from web security group
  }
  
  ingress {
    description = "SSH from within VPC only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Only from within VPC
  }
  
  # OUTBOUND RULES - Allow outbound for updates
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Database Security Group"
    Type = "Database"
  }
}

# OUTPUT VALUES - Display important information after creation
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.learning_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.learning_vpc.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "web_security_group_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.web_sg.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
}