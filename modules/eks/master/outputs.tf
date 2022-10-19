output "ca" {
  value = aws_eks_cluster.this.certificate_authority.0.data
}

output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "name" {
  value = aws_eks_cluster.this.name
}