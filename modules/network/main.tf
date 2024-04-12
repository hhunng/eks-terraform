resource "aws_subnet" "create_public_subnets" {
  for_each   = var.public_subnet_cidr_blocks
  vpc_id     = var.vpc_id
  cidr_block = each.value.ip_range
  map_public_ip_on_launch = true
  tags = {
    Name = each.value.tags.Name
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  availability_zone = each.value.availability_zone
}

resource "aws_subnet" "create_private_subnets" {
  for_each   = var.private_subnet_cidr_blocks
  vpc_id     = var.vpc_id
  cidr_block = each.value.ip_range
  tags = {
    Name = each.value.tags.Name
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb" = 1
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
  for_each       = aws_subnet.create_public_subnets
  route_table_id = aws_route_table.create_route_table.id
  subnet_id      = each.value.id
}

resource "aws_security_group" "allow_SSH" {
  name        = "${var.vpc_pool[0].tags.Name}-sg"
  description = "Allow SSH from any hosts"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.custom_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = [var.default-gateway-ip]
    prefix_list_ids = []
  }
}

resource "aws_eip" "eip_allocations" {
  for_each = aws_subnet.create_public_subnets
  depends_on = [aws_internet_gateway.create-igw]
}

resource "aws_nat_gateway" "gw" {
  for_each = aws_subnet.create_public_subnets
  allocation_id = aws_eip.eip_allocations[each.value.tags.Name].id
  subnet_id = aws_subnet.create_public_subnets[each.value.tags.Name].id
}