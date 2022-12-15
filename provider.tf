terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.44"
    }
  }
}

data "aws_availability_zones" "available" {}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["/home/mattia/.aws/credentials"]
}
