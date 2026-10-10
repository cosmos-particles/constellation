resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "${var.cluster_name}-EKSClusterPolicy"
  path        = var.path
  description = "Grants the EKS control plane permissions to manage EC2, ELB, and Auto Scaling resources on behalf of the cluster."
  policy      = file("${path.module}/files/eks-cluster-policy.json")
  tags        = var.tags
}

resource "aws_iam_policy" "eks_block_storage_policy" {
  name        = "${var.cluster_name}-EKSBlockStoragePolicyV2"
  path        = var.path
  description = "Grants the EKS control plane permissions to manage EBS volumes and snapshots for the cluster's block storage."
  policy      = file("${path.module}/files/eks-block-storage-policy-v2.json")
  tags        = var.tags
}

resource "aws_iam_policy" "eks_networking_policy" {
  name        = "${var.cluster_name}-EKSNetworkingPolicy"
  path        = var.path
  description = "Grants the EKS control plane permissions to manage ENIs and VPC networking for the cluster."
  policy      = file("${path.module}/files/eks-networking-policy.json")
  tags        = var.tags
}

resource "aws_iam_policy" "eks_compute_policy" {
  name        = "${var.cluster_name}-EKSComputePolicy"
  path        = var.path
  description = "Grants the EKS control plane permissions to launch and manage EC2 compute capacity for the cluster's node pools."
  policy      = file("${path.module}/files/eks-compute-policy.json")
  tags        = var.tags
}

resource "aws_iam_policy" "eks_load_balancing_policy" {
  name        = "${var.cluster_name}-EKSLoadBalancingPolicy"
  path        = var.path
  description = "Grants the EKS control plane permissions to manage load balancers, target groups, and listeners for the cluster's ingress/service resources."
  policy      = file("${path.module}/files/eks-load-balancing-policy.json")
  tags        = var.tags
}
