resource "aws_subnet" "create_public_subnets" {
    for_each = var.public_subnet_cidr_blocks
    vpc_id = var.vpc_id
    cidr_block = each.value.ip_range
    tags = {
        Name = each.value.tags.Name
    }
    availability_zone = each.value.availability_zone
}

resource "aws_subnet" "create_private_subnets" {
    for_each = var.private_subnet_cidr_blocks
    vpc_id = var.vpc_id
    cidr_block = each.value.ip_range
    tags = {
        Name = each.value.tags.Name
    }
    availability_zone = each.value.availability_zone
}

resource "aws_internet_gateway" "create-igw" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.vpc_pool[0].tags.Name}-igw"
    }
}

resource "aws_route_table" "create_route_table" {
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
    for_each = aws_subnet.create_public_subnets
    route_table_id = aws_route_table.create_route_table.id
    subnet_id = each.value.id
}

resource "aws_security_group" "allow_HTTP" {
    name = "${var.vpc_pool[0].tags.Name}-sg"
    description = "Allow SSH from any hosts"
    vpc_id = var.vpc_id
    
    dynamic "ingress" {
      for_each = var.custom_ports
      content {
        from_port = ingress.key
        to_port = ingress.key
        protocol = "tcp"
        cidr_blocks = ingress.value
      }
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [var.default-gateway-ip]
        prefix_list_ids = []
    }
}

# to get all the elements of the array - aws_subnet_example[*]