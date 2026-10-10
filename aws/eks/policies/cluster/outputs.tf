output "eks_cluster_policy_arn" {
  description = "ARN of the EKS cluster control-plane policy."
  value       = aws_iam_policy.eks_cluster_policy.arn
}

output "eks_block_storage_policy_arn" {
  description = "ARN of the EKS cluster block-storage policy."
  value       = aws_iam_policy.eks_block_storage_policy.arn
}

output "eks_networking_policy_arn" {
  description = "ARN of the EKS cluster networking policy."
  value       = aws_iam_policy.eks_networking_policy.arn
}

output "eks_compute_policy_arn" {
  description = "ARN of the EKS cluster compute policy."
  value       = aws_iam_policy.eks_compute_policy.arn
}

output "eks_load_balancing_policy_arn" {
  description = "ARN of the EKS cluster load-balancing policy."
  value       = aws_iam_policy.eks_load_balancing_policy.arn
}

output "cluster_role_policy_arns" {
  description = "All policy ARNs required for the EKS Auto Mode cluster role, keyed by logical name, ready to pass to the roles module's policy_arns variable."
  value = {
    eks_cluster_policy        = aws_iam_policy.eks_cluster_policy.arn
    eks_block_storage_policy  = aws_iam_policy.eks_block_storage_policy.arn
    eks_networking_policy     = aws_iam_policy.eks_networking_policy.arn
    eks_compute_policy        = aws_iam_policy.eks_compute_policy.arn
    eks_load_balancing_policy = aws_iam_policy.eks_load_balancing_policy.arn
  }
}
