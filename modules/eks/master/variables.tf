variable "eks_worker_nodes_subnets" {
  type = list(string)
}
variable "eks_master_asg" {}

variable "name" {}
variable "region" {}
variable "eks_cluster_version" {}
variable "eks_platform_version" {
  type    = string
  default = "eks.4"
}