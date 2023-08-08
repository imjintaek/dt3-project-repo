resource "aws_eks_node_group" "nodegroup" {
  cluster_name      = aws_eks_cluster.cluster.name
  node_group_name   = "eks-nodegroup-${var.prefix}-${var.aws_region_code}"
  node_role_arn     = aws_iam_role.nodegrouprole.arn
  subnet_ids        = "${var.eks_subnet_ids}"

  scaling_config {
    desired_size    = 2
    max_size        = 3 
    min_size        = 2
  }

  update_config {
    max_unavailable = 1
  }

	remote_access {
		ec2_ssh_key               = var.eks_node_public_key
		source_security_group_ids = [ var.admin_sg_id ]
	}

  depends_on = [
    aws_iam_role_policy_attachment.nodegrouprole-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodegrouprole-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodegrouprole-AmazonEC2ContainerRegistryReadOnly,
  ]
}
