module "eks" {
  source  = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name = var.eks_cluster_name

  iam_role_name = "${var.eks_cluster_name}-cluster"
  iam_role_tags = {
    Name = "${var.eks_cluster_name}-cluster"
  }


  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true

  create_cluster_security_group = false
  cluster_security_group_id     = aws_security_group.control_plane_sg.id

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  create_node_security_group = false
  node_security_group_id     = aws_security_group.data_plane_sg.id

  eks_managed_node_groups = {
    private-nodes = {

      name           = "private-nodes"
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3a.small"]

      desired_size = 1
      max_size     = 2
      min_size     = 1

      iam_role_additional_policies = {
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      tags = {
        LAB   = "tesi_mattia"
        infra = "terraform"
      }
    }
  }



  enable_irsa = false

  cluster_addons = {
    "vpc-cni" = {
      addon_version     = "v1.12.0-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = {
    LAB   = "tesi_mattia"
    infra = "terraform"
  }
}
