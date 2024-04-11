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

resource "aws_internet_gateway" "create-igw" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.vpc_pool[0].tags.Name}-igw"
    }
}

resource "aws_route_table" "create_route_table" {
    count = length(var.private_subnet_cidr_blocks)
    vpc_id = var.vpc_id
    route {
        cidr_block = var.default-gateway-ip
        gateway_id = aws_internet_gateway.create-igw.id
    }
    tags = {
        Name = "${var.vpc_pool[0].tags.Name}-igw-route-table"
    }
}

resource "aws_route_table_association" "associate_subnet" {
    count = length(aws_subnet.create_public_subnets)
    route_table_id = aws_route_table.create_route_table.id
    subnet_id = aws_subnet.create_public_subnets[count.index]
}

resource "aws_route_table" "create_route_table" {
    vpc_id = var.vpc_id

    route {
        cidr_block = var.default-gateway-ip
        gateway_id = aws_internet_gateway.create-igw.id
    }
    
    tags =  {
        Name = "${var.vpc_pool[0].tags.Name}-vpc-rtb"
    }
}

resource "aws_route_table_association" "associate_subnet" {
    route_table_id = aws_route_table.create_route_table.id
    subnet_id = aws_subnet.create_subnet.id
}

resource "aws_security_group" "allow_HTTP" {
    name = "${var.vpc_pool[0].tags.Name}-sg"
    description = "Allow SSH from any hosts"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.default-gateway-ip]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [var.default-gateway-ip]
        prefix_list_ids = []
    }
}

