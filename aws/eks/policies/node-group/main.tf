resource "aws_iam_policy" "eks_worker_node_minimal_policy" {
  name        = "${var.cluster_name}-EKSWorkerNodeMinimalPolicy"
  path        = var.path
  description = "Grants worker nodes permission to assume an EKS Pod Identity role on behalf of pods."
  policy      = file("${path.module}/files/eks-worker-node-minimal-policy.json")
  tags        = var.tags
}

resource "aws_iam_policy" "ecr_pull_only_policy" {
  name        = "${var.cluster_name}-ECRPullOnlyPolicy"
  path        = var.path
  description = "Grants worker nodes permission to pull container images from private ECR repositories."
  policy      = file("${path.module}/files/ecr-pull-only-policy.json")
  tags        = var.tags
}

resource "aws_iam_policy" "ecr_public_read_only_policy" {
  name        = "${var.cluster_name}-ECRPublicReadOnlyPolicy"
  path        = var.path
  description = "Grants worker nodes read-only access to public ECR repositories."
  policy      = file("${path.module}/files/ecr-public-read-only-policy.json")
  tags        = var.tags
}
