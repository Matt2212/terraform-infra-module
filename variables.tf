variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "vpc_name" {
  type    = string
  default = "eks-lab-vpc-module"
}

variable "eks_cluster_name" {
  type    = string
  default = "eks-lab-cluster-module"
}

variable "subnets_num" {
  type    = number
  default = 2
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
