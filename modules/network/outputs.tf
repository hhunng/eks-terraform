output "public_subnet-1a_id" {
  value = aws_subnet.create_public_subnets["public_subnet-1a"]
}
output "public_subnet-1b_id" {
  value = aws_subnet.create_public_subnets["public_subnet-1b"]
}
output "private_subnet-1a_id" {
  value = aws_subnet.create_private_subnets["private_subnet-1a"]
}
output "private_subnet-1b_id" {
  value = aws_subnet.create_private_subnets["private_subnet-1b"]
}