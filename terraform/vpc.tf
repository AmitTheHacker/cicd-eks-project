# ============================================
# VPC + SUBNETS + NAT GATEWAY
# ============================================
# Hum AWS ke official VPC module use karenge (community-tested)

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  # 2 Availability Zones use karo (High Availability)
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]     # EKS nodes yahan chalenge
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] # LoadBalancer yahan hoga

  enable_nat_gateway   = true # Private subnets ko internet dene ke liye
  single_nat_gateway   = true # Cost bachane ke liye 1 NAT only
  enable_dns_hostnames = true # EKS ke liye zaroori

  # EKS ke liye special tags (bahut important!)
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}