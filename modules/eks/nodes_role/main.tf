# EKS Nodes role
resource "aws_iam_role" "eks_nodes" {
  name        = "eks-nodes-${var.name}-${var.region}"
  description = "Allows eks nodes to join eks cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "eks_cluster_autoscaling" {
  statement {
    sid = "1"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:DescribeLaunchConfigurations",
      "ec2:DescribeLaunchTemplateVersions",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_cluster_autoscaling" {
  # count = "${var.attach_infrastructure_policy ? 1 : 0}"

  name   = "eks-nodes-cluster-autoscaling-${var.name}-${var.region}"
  policy = data.aws_iam_policy_document.eks_cluster_autoscaling.json
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaling" {
  # count = "${var.attach_infrastructure_policy ? 1 : 0}"

  policy_arn = aws_iam_policy.eks_cluster_autoscaling.arn
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_nodes_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.eks_nodes.name
}


resource "aws_iam_instance_profile" "eks_nodes" {
  name = "eks-nodes-${var.name}-${var.region}"
  role = aws_iam_role.eks_nodes.name
}