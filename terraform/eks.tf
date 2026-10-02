# ============================================
# EKS CLUSTER + MANAGED NODE GROUP
# ============================================
# Hum official EKS module use karenge

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31" # Kubernetes version

  # VPC se subnets lo
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Public access (humare laptop se kubectl chalane ke liye)
  cluster_endpoint_public_access = true

  # Addons (zaroori Kubernetes components)
  cluster_addons = {
    coredns    = {} # DNS resolution
    kube-proxy = {} # Networking
    vpc-cni    = {} # Pod networking
  }

  # Managed Node Group (worker nodes)
  eks_managed_node_groups = {
    main = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND" # SPOT bhi use kar sakte ho cost ke liye
    }
  }

  # EKS Access Entry (humara IAM user cluster access kar sake)
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}