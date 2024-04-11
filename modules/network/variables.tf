variable "vpc_id" {
    description = "create EKS VPC"
}
variable "public_subnet_cidr_blocks" {
    description = "create VPC subnets"
}
variable "private_subnet_cidr_blocks" {
    description = "create VPC subnets"
}

variable "vpc_pool" {
    description = "create VPC"
}

variable "default-gateway-ip" {
    description = "create default gateway ip range"
}

variable "custom_ports" {
    description = "define custom ports"
}