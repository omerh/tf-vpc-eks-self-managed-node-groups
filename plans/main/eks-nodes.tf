module "eks_role" {
  source = "../../modules/eks/nodes_role"
  name   = var.name
  region = var.region
}

### EKS m6g.medium ###
module "eks_node_v2_med" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-medium"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["m6g.medium"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}

### EKS m6g.large ###
module "eks_node_v2_large" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-large"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["m6g.large"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}

### EKS m6g.large ###
module "eks_node_v2_xlarge" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-xlarge"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["m6g.xlarge"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}


### EKS m6g.medium ###
module "eks_node_v2_burst_med" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-burst-medium"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["t4g.medium"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}

### EKS m6g.large ###
module "eks_node_v2_burst_large" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-burst-large"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["t4g.large"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}

### EKS m6g.large ###
module "eks_node_v2_burst_xlarge" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-burst-xlarge"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["t4g.xlarge"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}

module "eks_node_v2_im4gn_xlarge" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "arm-im4gn-xlarge"
  node_arch            = "arm64-node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["im4gn.xlarge"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}

module "eks_node_v2_x86_large" {
  source               = "../../modules/eks/nodesv2"
  eks_ca               = module.eks.ca
  eks_cluster_name     = module.eks.name
  eks_endpoint         = module.eks.endpoint
  group                = "x86-m5-large"
  node_arch            = "node"
  name                 = var.name
  eks_nodes_version    = var.eks_nodes_version
  security_groups      = [aws_security_group.allow_inboud.id]
  iam_instance_profile = module.eks_role.eks_node_profile_name
  ssh_key_name         = var.ssh_key_name
  eks_node_min_size    = 0
  eks_node_max_size    = 10
  #   on_demand_base_capacity                  = 1
  #   on_demand_percentage_above_base_capacity = 50
  vpc_zone_identifier = module.vpc.private_subnets
  node_instance_types = ["m5a.large"]
  #   spot_allocation_strategy                 = "capacity-optimized" # "lowest-price" # "capacity-optimized"
}