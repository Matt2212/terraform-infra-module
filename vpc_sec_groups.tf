locals {
  private_subnet_cidr_blocks = module.vpc.private_subnets_cidr_blocks
}

# Security group for data plane
resource "aws_security_group" "data_plane_sg" {
  name        = "k8s-data-plane-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for data plane"
  tags = {
    Name                                            = "k8s-data-plane-sg"
    LAB                                             = "tesi_mattia"
    infra                                           = "terraform"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

# Security group traffic rules
## Ingress rules
resource "aws_security_group_rule" "nodes" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = flatten([local.private_subnet_cidr_blocks])
}

resource "aws_security_group_rule" "nodes_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([local.private_subnet_cidr_blocks])
}

## Egress rule
resource "aws_security_group_rule" "node_outbound" {
  description       = "Egress rule for worker Kubelets and pods"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = concat(module.vpc_vpc-endpoints.endpoints["s3"].cidr_blocks, [module.vpc.vpc_cidr_block])
}

# Security group for control plane
resource "aws_security_group" "control_plane_sg" {
  name        = "k8s-control-plane-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for control plane"
  tags = {
    Name                                            = "k8s-control-plane-sg"
    LAB                                             = "tesi_mattia"
    infra                                           = "terraform"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

# Security group traffic rules
## Ingress rule
resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  description       = "Ingress rule for worker Kubelets and pods"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([local.private_subnet_cidr_blocks])
}

## egress rule
resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  description       = "Allow cluster control plane to send communication to the worker Kubelets and pods"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = concat(module.vpc_vpc-endpoints.endpoints["s3"].cidr_blocks, [module.vpc.vpc_cidr_block])
}

output "value" {
  value = concat(module.vpc_vpc-endpoints.endpoints["s3"].cidr_blocks, [module.vpc.vpc_cidr_block])
}