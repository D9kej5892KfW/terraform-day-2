# This is your first Terraform configuration file!
# Everything after # is a comment

# PROVIDER BLOCK - Tell Terraform how to connect to AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Where to download the AWS provider
      version = "~> 5.0"         # Use version 5.x (latest stable)
    }
  }
}

# PROVIDER CONFIGURATION - How to authenticate with AWS
provider "aws" {
  region = "us-east-1"  # Which AWS region to use
  # Terraform will automatically use your AWS CLI credentials
}

# RESOURCE BLOCK - What infrastructure to create
# This creates an S3 bucket (storage service)
resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "terraform-learning-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "My First Terraform Bucket"
    Purpose     = "Learning"
    CreatedWith = "Terraform"
    Environment = "Development"
    LastModified = "Today"
  }
}

# RANDOM ID - Creates a unique suffix for bucket name
# (S3 bucket names must be globally unique across ALL AWS accounts)
resource "random_id" "bucket_suffix" {
  byte_length = 4
}