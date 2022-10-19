resource "aws_eks_cluster" "this" {
  name                      = "${var.name}-${var.region}"
  version                   = var.eks_cluster_version
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids              = var.eks_worker_nodes_subnets
    security_group_ids      = [var.eks_master_asg]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]

  # lifecycle {
  #   ignore_changes = [
  #     platform_version,
  #   ]
  # }
}
