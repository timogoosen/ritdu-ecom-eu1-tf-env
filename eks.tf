

# resource "aws_eks_cluster" "prod_eks_cluster" {
#   count    = terraform.workspace == "prod" ? 1 : 0
#   name     = "${terraform.workspace}-eks-cluster"
#   role_arn = aws_iam_role.prod_eks_cluster[count.index].arn

#   vpc_config {
#     subnet_ids              = concat(data.terraform_remote_state.env.outputs.main_vpc_public_subnet_ids, data.terraform_remote_state.env.outputs.main_vpc_private_subnet_ids)
#     public_access_cidrs     = concat(var.office_ips, var.home_ips, ["102.65.42.6/32"], ["0.0.0.0/0"])
#     endpoint_private_access = true
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#   # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.prod_eks_cluster_AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.prod_eks_cluster_AmazonEKSServicePolicy,
#   ]
# }

# resource "aws_iam_openid_connect_provider" "prod_eks_cluster" {
#   count           = terraform.workspace == "prod" ? 1 : 0
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
#   url             = aws_eks_cluster.prod_eks_cluster[count.index].identity.0.oidc.0.issuer
# }

# resource "aws_eks_fargate_profile" "default" {
#   count                  = terraform.workspace == "prod" ? 1 : 0
#   cluster_name           = aws_eks_cluster.prod_eks_cluster[count.index].name
#   fargate_profile_name   = "default"
#   pod_execution_role_arn = aws_iam_role.prod_eks_cluster[count.index].arn
#   subnet_ids             = data.terraform_remote_state.env.outputs.main_vpc_private_subnet_ids

#   selector {
#     namespace = "default"
#   }
# }

# resource "aws_eks_fargate_profile" "kube_system" {
#   count                  = terraform.workspace == "prod" ? 1 : 0
#   cluster_name           = aws_eks_cluster.prod_eks_cluster[count.index].name
#   fargate_profile_name   = "kube-system"
#   pod_execution_role_arn = aws_iam_role.prod_eks_cluster[count.index].arn
#   subnet_ids             = data.terraform_remote_state.env.outputs.main_vpc_private_subnet_ids

#   selector {
#     namespace = "kube-system"
#   }
# }

# resource "aws_iam_role" "prod_eks_cluster" {
#   count = terraform.workspace == "prod" ? 1 : 0
#   name  = "${terraform.workspace}-eks-cluster"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks-fargate-pods.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Federated": "arn:aws:iam::471953789682:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/47B0B0DD1B1B0C09DFA3204861A9A241"
#       },
#       "Action": "sts:AssumeRoleWithWebIdentity"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy" "prod_eks_cluster_extra" {
#   count       = terraform.workspace == "prod" ? 1 : 0
#   name        = "prod-eks-cluster-extra"
#   description = "EKS extra policy"
#   policy      = templatefile("eks_extra_policy.json", { EKS_ARN = aws_eks_cluster.prod_eks_cluster[count.index].arn })
# }


# resource "aws_iam_role_policy_attachment" "prod_eks_cluster_AmazonEKSClusterPolicy" {
#   count      = terraform.workspace == "prod" ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.prod_eks_cluster[count.index].name
# }

# resource "aws_iam_role_policy_attachment" "prod_eks_cluster_extra" {
#   count      = terraform.workspace == "prod" ? 1 : 0
#   policy_arn = aws_iam_policy.prod_eks_cluster_extra[count.index].arn
#   role       = aws_iam_role.prod_eks_cluster[count.index].name
# }

# resource "aws_iam_role_policy_attachment" "prod_eks_cluster_AmazonEKSServicePolicy" {
#   count      = terraform.workspace == "prod" ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = aws_iam_role.prod_eks_cluster[count.index].name
# }

# resource "aws_iam_role_policy_attachment" "prod_eks_cluster_AmazonEKSFargatePodExecutionRolePolicy" {
#   count      = terraform.workspace == "prod" ? 1 : 0
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
#   role       = aws_iam_role.prod_eks_cluster[count.index].name
# }

# output "eks_cluster" {
#   value = terraform.workspace == "prod" ? aws_eks_cluster.prod_eks_cluster[0] : null
# }