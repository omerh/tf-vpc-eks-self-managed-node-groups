# Get latest AMI
data "aws_ami" "eks_arm_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-${var.node_arch}-${var.eks_nodes_version}*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

locals {
  launch_config = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint ${var.eks_endpoint} \
  --b64-cluster-ca ${var.eks_ca} \
  --kubelet-extra-args --node-labels=${var.group}=true \
  ${var.eks_cluster_name}
USERDATA

 cluster_tags = {
    Name = "eks-${var.name}-${var.group}"
    Environment = var.name
    "${var.group}" = true
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    KubernetesCluster = var.eks_cluster_name
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/node-template/label/${var.group}" = "true"
  }
}



resource "aws_launch_template" "eks" {
  name_prefix = format("eks-nodev2-%s-%s", var.name, var.group)

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
    delete_on_termination       = var.network_interface_delete_on_termination
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  image_id      = data.aws_ami.eks_arm_worker.id
  user_data     = base64encode(local.launch_config)
  key_name      = var.ssh_key_name
  ebs_optimized = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks" {

  count = length(var.vpc_zone_identifier)

  name_prefix = format("eks-nodev2-%s-%s-az-%s-", var.name, var.group, count.index)
  max_size    = var.eks_node_max_size
  min_size    = var.eks_node_min_size

  vpc_zone_identifier  = [element(var.vpc_zone_identifier, count.index)]
  termination_policies = var.termination_policies
  default_cooldown     = var.default_cooldown

  mixed_instances_policy {
    # instances_distribution {
    #   spot_allocation_strategy                 = var.spot_allocation_strategy
    #   on_demand_base_capacity                  = var.on_demand_base_capacity
    #   on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
    # }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks.id
        version            = aws_launch_template.eks.latest_version
      }

      dynamic "override" {
        for_each = var.node_instance_types

        content {
          instance_type = override.value
        }

      }
    }

  }

  # tags = concat(
  #   tolist([
  #     tomap({"key" = "Name", "value" = "eks-${var.name}-${var.group}", "propagate_at_launch" = true}),
  #     tomap({"key" = "Environment", "value" = var.name, "propagate_at_launch" = true}),
  #     tomap({"key" = var.group, "value" = "true", "propagate_at_launch" = true}),
  #     tomap({"key" = "kubernetes.io/cluster/${var.eks_cluster_name}", "value" = "owned", "propagate_at_launch" = true}),
  #     tomap({"key" = "KubernetesCluster", "value" = var.eks_cluster_name, "propagate_at_launch" = true}),
  #     tomap({"key" = "k8s.io/cluster-autoscaler/enabled", "value" = "true", "propagate_at_launch" = true}),
  #     tomap({"key" = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}", "value" = "owned", "propagate_at_launch" = true}),
  #     tomap({"key" = "k8s.io/cluster-autoscaler/node-template/label/${var.group}", "value" = "true", "propagate_at_launch" = true}),
  #     tomap({"key" = "az-count", "value" = count.index, "propagate_at_launch" = true}),
  #   ]),
  # var.tags)

  dynamic "tag" {
    for_each = merge(local.cluster_tags, var.tags, {az_count = count.index})
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      desired_capacity,
    ]
  }
}
