terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25"
    }
  }
}

provider "aws" {
  region                   = var.provider_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

terraform {
  backend "s3" {
    bucket  = "tf-playground-test"
    key     = "main/plan"
    region  = "eu-west-1"
    encrypt = true
    profile = "default"
  }
}
