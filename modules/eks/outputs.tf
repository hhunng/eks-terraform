output "eks_issuer" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer

}

output "eks_role_nodes_name" {
  value = aws_iam_role.nodes_general.name
}

output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

