# Provider
provider_region = "eu-west-1"

# General
name         = "production"
region       = "eu-west-1"
ssh_key_name = "eu-west-1-default"

# Tags
tags = {
  Terraform   = "true"
  Environment = "production"
  Name        = "production"
}

# VPC
cidr                = "10.202.0.0/16"
azs                 = ["eu-west-1a", "eu-west-1b"]
private_subnets     = ["10.202.0.0/19", "10.202.32.0/19"]
public_subnets      = ["10.202.128.0/19", "10.202.160.0/19"]
database_subnets    = ["10.202.96.0/24", "10.202.97.0/24"]
elasticache_subnets = ["10.202.99.0/24", "10.202.100.0/24"]

# EKS
eks_version       = "1.23"
eks_nodes_version = "1.23"
