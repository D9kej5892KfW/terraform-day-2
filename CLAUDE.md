# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose
**Terraform Learning Journey**: A structured, concept-first approach to understanding Infrastructure as Code with Terraform and AWS.

## Learning Profile
- **Experience Level**: Complete Terraform beginner with solid cloud concepts knowledge
- **Primary Goal**: Understanding Terraform concepts and the "why" behind decisions
- **Cloud Focus**: AWS (staying within free tier limits)
- **Learning Style**: Step-by-step progression with emphasis on conceptual understanding
- **Infrastructure Scope**: EC2, VPC/Networking, Storage (S3), Databases (RDS), IAM/Security

## Recommended Persona
Use `--persona-mentor` for all interactions to prioritize:
- Educational explanations over quick solutions
- Conceptual understanding before hands-on implementation
- Step-by-step learning progression
- Clear reasoning behind each Terraform design decision

## Learning Roadmap

### Phase 1: Core Concepts (Weeks 1-2)
1. **Terraform Fundamentals**
   - What is Infrastructure as Code and why it matters
   - Terraform vs other IaC tools (CloudFormation, Pulumi)
   - Terraform workflow: write → plan → apply
   - Understanding state files and why they exist

2. **Basic Terraform Structure**
   - Providers and why we need them
   - Resources vs Data Sources (when to use each)
   - Variables and outputs (making configurations reusable)
   - Basic AWS provider setup

3. **First Simple Resource**
   - Single EC2 instance (t2.micro/t3.micro in free tier)
   - Understanding the provider block
   - Resource arguments vs attributes
   - State inspection and terraform show

### Phase 2: Building Blocks (Weeks 3-4)
4. **Networking Foundation**
   - VPC concepts: why not use default VPC
   - Subnets, route tables, internet gateways
   - Security groups vs NACLs (when to use each)
   - Free tier networking components

5. **Storage and Data**
   - S3 bucket creation and management
   - Understanding S3 bucket policies vs IAM policies
   - RDS free tier instance (db.t3.micro)
   - When to use managed vs self-managed databases

### Phase 3: Security and Organization (Weeks 5-6)
6. **IAM and Security**
   - IAM roles vs users vs policies (principle of least privilege)
   - Instance profiles for EC2
   - Terraform service accounts and permissions
   - Managing secrets and sensitive data

7. **Code Organization**
   - When and why to use modules
   - Local values and when they're useful
   - File organization strategies
   - Comments and documentation in Terraform

### Phase 4: Advanced Concepts (Weeks 7-8)
8. **State Management**
   - Local vs remote state (why remote is better)
   - State locking and why it prevents conflicts
   - State file structure and what's stored
   - Terraform refresh and import

9. **Dependencies and Data Flow**
   - Implicit vs explicit dependencies
   - Data sources for existing infrastructure
   - Output values for module communication
   - Count and for_each patterns

## Development Commands
```bash
# Initialize Terraform in a new directory
terraform init

# Validate configuration syntax
terraform validate

# Preview changes before applying
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources in state
terraform state list

# Destroy infrastructure
terraform destroy
```

## Project Structure
```
terraform-learning/
├── 01-basics/          # Single resource examples
├── 02-networking/      # VPC and networking
├── 03-compute/         # EC2 instances and scaling
├── 04-storage/         # S3 and RDS examples
├── 05-security/        # IAM and security groups
├── 06-modules/         # Custom modules
└── 07-advanced/        # State management, imports
```

## Key Learning Principles
1. **Understand Before Implementing**: Always explain the concept before writing code
2. **Question Everything**: Why this resource? Why these arguments? Why this pattern?
3. **Start Small**: Single resources before complex architectures
4. **Free Tier Focus**: All examples must stay within AWS free tier limits
5. **Real-World Context**: Connect each concept to practical use cases
6. **State Awareness**: Always understand what's happening with Terraform state

## AWS Free Tier Resources to Focus On
- EC2: t2.micro/t3.micro instances (750 hours/month)
- RDS: db.t2.micro/db.t3.micro (750 hours/month)
- S3: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- VPC: All VPC components are free
- IAM: All IAM resources are free
- CloudWatch: Basic monitoring included

## Teaching Approach
- Concept introduction → Why it exists → How Terraform handles it → Simple example → Discussion of alternatives
- Always ask "What problem does this solve?" before introducing new concepts
- Connect Terraform patterns to broader infrastructure and software engineering principles
