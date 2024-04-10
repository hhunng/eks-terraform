provider "aws" {}

resource "aws_vpc" "create_vpc" {
    cidr_block = var.vpc_pool[0].cidr_block
    tags = {
        Name = var.vpc_pool[0].tags.Name
        Env = var.vpc_pool[0].tags.Env
    }
}


