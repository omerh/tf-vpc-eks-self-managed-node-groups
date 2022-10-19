output "eks_node_profile_name" {
  value = aws_iam_instance_profile.eks_nodes.name
}

output "eks_node_profile_id" {
  value = aws_iam_instance_profile.eks_nodes.id
}

output "eks_node_profile_arn" {
  value = aws_iam_instance_profile.eks_nodes.arn
}

output "eks_aws_auth_role_arn" {
  value = aws_iam_role.eks_nodes.arn
}