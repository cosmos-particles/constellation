output "eks_worker_node_minimal_policy_arn" {
  description = "ARN of the EKS worker node minimal policy."
  value       = aws_iam_policy.eks_worker_node_minimal_policy.arn
}

output "ecr_pull_only_policy_arn" {
  description = "ARN of the ECR pull-only policy."
  value       = aws_iam_policy.ecr_pull_only_policy.arn
}

output "ecr_public_read_only_policy_arn" {
  description = "ARN of the ECR public read-only policy."
  value       = aws_iam_policy.ecr_public_read_only_policy.arn
}

output "node_group_role_policy_arns" {
  description = "All policy ARNs required for the EKS Auto Mode node role, keyed by logical name, ready to pass to the roles module's policy_arns variable."
  value = {
    eks_worker_node_minimal_policy = aws_iam_policy.eks_worker_node_minimal_policy.arn
    ecr_pull_only_policy           = aws_iam_policy.ecr_pull_only_policy.arn
    ecr_public_read_only_policy    = aws_iam_policy.ecr_public_read_only_policy.arn
  }
}
