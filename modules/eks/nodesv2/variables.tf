variable "eks_nodes_version" {}
variable "group" {}
variable "eks_endpoint" {}
variable "eks_ca" {}
variable "eks_cluster_name" {}
variable "associate_public_ip_address" {
  default = false
}
variable "iam_instance_profile" {}
variable "security_groups" {
  type = list(string)
}
variable "ssh_key_name" {}
# variable "node_instance_type" {}
variable "vpc_zone_identifier" {}
variable "eks_node_max_size" {}
variable "eks_node_min_size" {}
variable "default_cooldown" {
  default = 60
}

variable "name" {
  type = string
}

variable "spot_allocation_strategy" {
  default = "capacity-optimized"
}
variable "on_demand_percentage_above_base_capacity" {
  default = 0
}

variable "node_instance_types" {
  type = list(string)
}
variable "termination_policies" {
  type    = list(string)
  default = ["OldestLaunchConfiguration"]
}
variable "weighted_capacity" {
  default = 30
}
variable "network_interface_delete_on_termination" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_arch" {
  type        = string
  description = "choose node for x86 or arm64-node"
  default     = "node"
}