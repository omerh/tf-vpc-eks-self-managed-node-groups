resource "aws_security_group" "eks_master" {
  name        = "${var.name}-${var.region}-eks_master"
  description = "${var.name}-${var.region}-eks_master"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.eks_tags)
}

locals {
  eks_tags = {
    "kubernetes.io/cluster/${var.name}-${var.region}" = "owned"
    "KubernetesCluster"                               = "${var.name}"
    "Environment"                                     = var.name
    "kubernetes.io/cluster/"                          = "shared"
  }
}

module "eks" {
  source                   = "../../modules/eks/master"
  name                     = var.name
  region                   = var.region
  eks_worker_nodes_subnets = module.vpc.private_subnets
  eks_master_asg           = aws_security_group.eks_master.id
  eks_cluster_version      = var.eks_version
}