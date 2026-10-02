# ============================================
# OUTPUTS (Terraform apply ke baad screen pe dikhega)
# ============================================

output "cluster_name" {
  description = "EKS cluster ka naam"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "ecr_repository_url" {
  description = "ECR Docker image push URL"
  value       = aws_ecr_repository.app.repository_url
}

output "github_actions_role_arn" {
  description = "GitHub Actions IAM Role ARN (secrets me daalni hai)"
  value       = aws_iam_role.github_actions.arn
}

output "kubectl_config_command" {
  description = "Yeh command run karke kubectl setup karo"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}