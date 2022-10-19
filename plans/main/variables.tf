variable "provider_region" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "elasticache_subnets" {
  type = list(string)
}

variable "eks_version" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "eks_nodes_version" {
  type = string
}
