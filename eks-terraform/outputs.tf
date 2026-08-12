

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.my_cluster.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.my_cluster.endpoint
}

output "configure_kubectl" {
  description = "Command to update your local kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.my_cluster.name}"
}