resource "aws_subnet" "create_public_subnets" {
    count = length(var.public_subnet_cidr_blocks)
    vpc_id = var.vpc_id
    cidr_block = var.public_subnet_cidr_blocks[count.index].ip_range
    tags = {
        Name = var.public_subnet_cidr_blocks[count.index].tags.Name
    }
}

resource "aws_subnet" "create_private_subnets" {
    count = length(var.private_subnet_cidr_blocks)
    vpc_id = var.vpc_id
    cidr_block = var.private_subnet_cidr_blocks[count.index].ip_range
    tags = {
        Name = var.private_subnet_cidr_blocks[count.index].tags.Name
    }
}