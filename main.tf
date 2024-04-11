provider "aws" {}

resource "aws_vpc" "create_vpc" {
    cidr_block = var.vpc_pool[0].cidr_block
    tags = {
        Name = var.vpc_pool[0].tags.Name
        Env = var.vpc_pool[0].tags.Env
    }
}

module "terraform_vpc" {
    source = "./modules/network"
    vpc_id = aws_vpc.create_vpc.id
    public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
    private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
    default-gateway-ip = var.default_gateway_ip
    vpc_pool = var.vpc_pool
    custom_ports = var.custom_ports
}

