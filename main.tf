provider "aws" {}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "tfvarsmodule"
}

locals {
  tfvars_cred = jsondecode(
  data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_vpc" "create_vpc" {
  cidr_block = var.vpc_pool[0].cidr_block

  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = var.vpc_pool[0].tags.Name
    Env  = var.vpc_pool[0].tags.Env
  }
}



module "terraform_vpc" {
  source                     = "./modules/network"
  vpc_id                     = aws_vpc.create_vpc.id
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  default-gateway-ip         = var.default_gateway_ip
  vpc_pool                   = var.vpc_pool
  custom_ports               = var.custom_ports
}

module "terraform_eks" {
  source = "./modules/eks"
  subnet_ids = [
    module.terraform_vpc.public_subnet-1a_id.id,
    module.terraform_vpc.public_subnet-1b_id.id,
    module.terraform_vpc.private_subnet-1a_id.id,
    module.terraform_vpc.private_subnet-1b_id.id
  ]
}

module "terraform_karpenter" {
  source = "./modules/karpenter"
  eks_node_object = module.terraform_eks.eks_node_object
  eks_issuer = module.terraform_eks.eks_issuer
  eks_role_nodes_name = module.terraform_eks.eks_role_nodes_name
  eks_endpoint = module.terraform_eks.eks_endpoint
  eks_data = module.terraform_eks.eks_data
  eks_cluster_id = module.terraform_eks.eks_cluster_id
}


