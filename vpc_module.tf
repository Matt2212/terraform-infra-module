module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  cidr = var.cidr_block
  azs  = data.aws_availability_zones.avzs.names

  enable_dns_support   = true
  enable_dns_hostnames = true

  private_subnets      = [for i in range(var.subnets_num) : cidrsubnet(var.cidr_block, 8, i)]
  private_subnet_names = [for i in range(var.subnets_num) : "private-subnet-${i}"]
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }

  vpc_tags = {
    Name                                            = var.vpc_name
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }

  tags = {
    LAB   = "tesi_mattia"
    infra = "terraform"
  }
}

module "vpc_vpc-endpoints" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.18.1"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.data_plane_sg.id]
  subnet_ids         = module.vpc.private_subnets

  endpoints = {
    s3 = {
      service         = "s3"
      route_table_ids = module.vpc.private_route_table_ids
      service_type    = "Gateway"
      tags            = { Name = "s3" }
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      tags                = { Name = "ec2" }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      tags                = { Name = "sts" }
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      tags                = { Name = "ecr_api" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      tags                = { Name = "ecr_dkr" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      tags                = { Name = "ssmmessages" }
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      tags                = { Name = "ec2messages" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      tags                = { Name = "ssm" }
    }
  }

  tags = {
    LAB   = "tesi_mattia"
    infra = "terraform"
  }
}
