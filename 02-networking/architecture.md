# VPC Architecture Visualization

## Overview
Your custom VPC network architecture built with Terraform.

## Architecture Diagram

```
                                 INTERNET
                                    ↑
                                    |
                        ┌───────────────────────┐
                        │   Internet Gateway    │
                        │   igw-0b054474...     │
                        └───────────────────────┘
                                    ↑
                                    |
        ┌─────────────────────────────────────────────────────────────┐
        │                    Learning VPC                             │
        │                 vpc-0ad8f1ed979a1d9f2                       │
        │                   CIDR: 10.0.0.0/16                        │
        │                                                             │
        │  ┌─────────────────────────┐    ┌─────────────────────────┐ │
        │  │     Public Subnet       │    │     Private Subnet      │ │
        │  │  subnet-031d9228...     │    │  subnet-07c88e52...     │ │
        │  │   CIDR: 10.0.1.0/24    │    │   CIDR: 10.0.2.0/24    │ │
        │  │   AZ: us-east-1a       │    │   AZ: us-east-1b       │ │
        │  │   Auto-assign Public   │    │   No Public IPs        │ │
        │  │   IPs: YES ✓           │    │   IPs: NO ✗            │ │
        │  │                        │    │                        │ │
        │  │  [Future: Web Servers] │    │ [Future: Databases]    │ │
        │  │  [Future: Load Balancer│    │ [Future: App Servers]  │ │
        │  └─────────────────────────┘    └─────────────────────────┘ │
        │              ↑                               ↑               │
        │              |                               |               │
        │    ┌─────────────────────┐         ┌─────────────────────┐   │
        │    │   Public Route      │         │   Default Route     │   │
        │    │   Table             │         │   Table (VPC)       │   │
        │    │ rtb-02fc2ca3...     │         │ (No IGW route)      │   │
        │    │ 0.0.0.0/0 → IGW     │         │                     │   │
        │    └─────────────────────┘         └─────────────────────┘   │
        └─────────────────────────────────────────────────────────────┘
```

## Components Created

### 1. VPC (Virtual Private Cloud)
- **ID**: vpc-0ad8f1ed979a1d9f2
- **CIDR**: 10.0.0.0/16 (65,536 IP addresses)
- **DNS**: Enabled (hostnames and resolution)
- **Your private network in AWS**

### 2. Public Subnet
- **ID**: subnet-031d9228dcbd36892
- **CIDR**: 10.0.1.0/24 (256 IP addresses: 10.0.1.0 - 10.0.1.255)
- **AZ**: us-east-1a
- **Internet Access**: YES (via Internet Gateway)
- **Auto Public IP**: Enabled
- **Purpose**: Web servers, load balancers, bastion hosts

### 3. Private Subnet
- **ID**: subnet-07c88e5232271d958
- **CIDR**: 10.0.2.0/24 (256 IP addresses: 10.0.2.0 - 10.0.2.255)
- **AZ**: us-east-1b
- **Internet Access**: NO
- **Auto Public IP**: Disabled
- **Purpose**: Databases, application servers, internal services

### 4. Internet Gateway
- **ID**: igw-0b054474d28a4638b
- **Purpose**: Provides internet access to public subnet
- **Attached to**: Learning VPC

### 5. Route Table (Public)
- **ID**: rtb-02fc2ca3ed18fa236
- **Routes**: 
  - Local VPC traffic (10.0.0.0/16) → Local
  - Internet traffic (0.0.0.0/0) → Internet Gateway
- **Associated with**: Public subnet only

### 6. Route Table Association
- **ID**: rtbassoc-0cae3e77f0ea581e1
- **Connects**: Public subnet to public route table

## Network Traffic Flow

### Public Subnet → Internet
```
EC2 Instance (10.0.1.x) → Route Table → Internet Gateway → Internet
```

### Private Subnet → Internet
```
EC2 Instance (10.0.2.x) → Route Table → ❌ NO ROUTE (Blocked)
```

### Inter-Subnet Communication
```
Public Subnet (10.0.1.x) ↔ Private Subnet (10.0.2.x) ✓ (Within VPC)
```

## Security Design

### Defense in Depth Layers
1. **Network Layer**: VPC isolation from other networks
2. **Subnet Layer**: Public vs Private subnet segregation  
3. **Routing Layer**: Controlled internet access via route tables
4. **Future**: Security Groups (instance-level firewalls)
5. **Future**: NACLs (subnet-level firewalls)

## High Availability
- **Multi-AZ**: Resources spread across us-east-1a and us-east-1b
- **Fault Tolerance**: If one AZ fails, other AZ remains operational
- **Best Practice**: Always design for multi-AZ deployment

## Cost Considerations
- **VPC**: Free
- **Subnets**: Free
- **Internet Gateway**: Free
- **Route Tables**: Free
- **Data Transfer**: Charged per GB (out to internet)

This architecture forms the foundation for scalable, secure AWS applications.