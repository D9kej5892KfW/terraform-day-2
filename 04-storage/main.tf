# Phase 2: S3 Bucket Policies vs IAM Policies
# This demonstrates the two ways to control S3 access

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

# Reference our existing S3 bucket from Phase 1
# This is a DATA SOURCE - reads existing infrastructure
data "aws_s3_bucket" "existing_bucket" {
  bucket = "terraform-learning-1c52c637"  # Your bucket name from Phase 1
}

# BUCKET POLICY - Controls access at the bucket level
# This is attached TO the bucket and controls WHO can access it
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = data.aws_s3_bucket.existing_bucket.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Allow read access from our VPC only
        Sid       = "AllowVPCAccess"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "${data.aws_s3_bucket.existing_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = "vpc-0ad8f1ed979a1d9f2"  # Our VPC from Phase 2
          }
        }
      },
      {
        # Allow our AWS account full access
        Sid       = "AllowAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::211125588329:root"  # Your account ID
        }
        Action   = "s3:*"
        Resource = [
          data.aws_s3_bucket.existing_bucket.arn,
          "${data.aws_s3_bucket.existing_bucket.arn}/*"
        ]
      }
    ]
  })
}

# PUBLIC ACCESS BLOCK - Security best practice
# Prevents accidental public access even if policies allow it
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = data.aws_s3_bucket.existing_bucket.id

  block_public_acls       = true
  block_public_policy     = true  
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# VERSIONING - Enable version control for objects
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = data.aws_s3_bucket.existing_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# SERVER-SIDE ENCRYPTION - Encrypt data at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = data.aws_s3_bucket.existing_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# OUTPUT - Show bucket information
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = data.aws_s3_bucket.existing_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = data.aws_s3_bucket.existing_bucket.arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = data.aws_s3_bucket.existing_bucket.bucket_domain_name
}