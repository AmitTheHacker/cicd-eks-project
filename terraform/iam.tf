# ============================================
# OIDC PROVIDER + GITHUB ACTIONS IAM ROLE
# ============================================

# Step 1: GitHub ka OIDC Provider AWS me register karo
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Step 2: IAM Role banao jo GitHub Actions use karega
resource "aws_iam_role" "github_actions" {
  name = "GitHubActions-Terraform-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_repo}:*",
            "repo:AmitTheHacker@55714630/cicd-eks-project@1395182448:*"
          ]
        }
      }
    }]
  })

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Step 3: Role me policies attach karo
resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Step 4: EKS cluster me is role ko access do (new feature)
resource "aws_eks_access_entry" "github_actions" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.github_actions.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_actions_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.github_actions.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  # 👈 FIXED: Wait for the access entry to be fully created first!
  depends_on = [
    aws_eks_access_entry.github_actions
  ]
}