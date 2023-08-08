output "eks_cluster_name" {
    description = "EKS Cluster Name"
    value       = aws_eks_cluster.cluster.name
}

output "eks_security_group_id" {
    description     =   "The ID of Security Group for EKS"
#   value           =   aws_security_group.eks.id
    value           =   aws_eks_node_group.nodegroup.resources[*].remote_access_security_group_id
}
