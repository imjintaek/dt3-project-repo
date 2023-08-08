resource "aws_eks_cluster" "cluster" {
  name         = "eks-cluster-${var.prefix}-${var.aws_region_code}"
  role_arn     = aws_iam_role.clusterrole.arn

  vpc_config {
    subnet_ids = "${var.eks_subnet_ids}"
#   subnet_ids = aws_subnet.private[*].id
#   subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id, aws_subnet.private[2].id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.clusterrole-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.clusterrole-AmazonEKSVPCResourceController,
  ]
}
