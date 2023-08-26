provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Name = "aws-auth-and-irsa"
      tag  = "aws-auth-and-irsa"
    }
  }
}

terraform {
  required_version = "~> 1.5.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2"
    }
  }
}
