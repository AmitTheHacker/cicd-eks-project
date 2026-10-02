# ============================================
# VARIABLES (Reusable values)
# ============================================
# Yeh ek dukan ki tarah hai - jahan se values nikalte hain

variable "aws_region" {
  description = "AWS region jahan sab resources banenge"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster ka naam"
  type        = string
  default     = "zidd-tf-cluster"
}

variable "ecr_repo_name" {
  description = "ECR repository ka naam"
  type        = string
  default     = "cicd-first-tf"
}

variable "vpc_cidr" {
  description = "VPC ka IP range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "github_repo" {
  description = "GitHub repo (user/repo format)"
  type        = string
  default     = "AmitTheHacker/cicd-eks-project"
}

variable "node_instance_type" {
  description = "EKS worker node ka EC2 type"
  type        = string
  default     = "t3.small"
}