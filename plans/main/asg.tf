resource "aws_security_group" "allow_inboud" {
  name        = "allow_inbound_traffic"
  description = "Allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr]
    description = "CIDR allow all"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound"
  }

  tags = merge(local.eks_tags)
}