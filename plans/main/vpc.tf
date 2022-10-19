module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr
  azs  = var.azs

  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets
  
  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_dns_support           = true

  enable_nat_gateway = true
  single_nat_gateway = false

  database_subnet_group_name = "${var.name}-database"
  database_subnet_tags = {
    Name = "${var.name}-database"
  }
  database_route_table_tags = {
    Name = "${var.name}-database"
  }

  elasticache_subnet_group_name = "${var.name}-elasticache"
  elasticache_subnet_tags = {
    Name = "${var.name}-elasticache"
  }
  elasticache_route_table_tags = {
    Name = "${var.name}-elasticache"
  }

  private_subnet_tags = {
    private                                           = "true"
    Name                                              = "${var.name}-private"
    "kubernetes.io/role/internal-elb"                 = "1"
    "kubernetes.io/cluster/${var.name}-${var.region}" = "owned"
  }

  public_subnet_tags = {
    public                                            = "true"
    Name                                              = "${var.name}-public"
    "kubernetes.io/role/elb"                          = "1"
    "kubernetes.io/cluster/${var.name}-${var.region}" = "owned"
  }


  public_route_table_tags = {
    public = "true"
    Name   = "${var.name}-public"
  }

  private_route_table_tags = {
    private = "true"
    Name    = "${var.name}-private"
  }

  tags = var.tags
}

module "vpc_endpoints" {
  source = "./.terraform/modules/vpc/modules/vpc-endpoints/"

  vpc_id = module.vpc.vpc_id
  endpoints = {
    s3 = {
      service      = "s3"
      tags         = { Name = "s3-vpc-endpoint-${var.name}" }
      service_type = "Gateway"
      route_table_ids = flatten([
        module.vpc.private_route_table_ids,
        module.vpc.public_route_table_ids,
        module.vpc.database_route_table_ids,
        module.vpc.elasticache_route_table_ids]
      )
    }
  }
}



### VPC Flow logs ###
resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id

  tags = {
    Name = "flow-logs-cloudwatch"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.name}-flow-log"
}

resource "aws_iam_role" "this" {
  name = "vpc-flow-log-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "this" {
  name = "vpc-flow-log-${var.name}-policy"
  role = aws_iam_role.this.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "s3:Put*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_flow_log" "s3" {
  log_destination      = aws_s3_bucket.this.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id

  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }

  tags = {
    Name = "flow-logs-s3"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "vpc-flow-logs-${var.name}-${var.region}"
}