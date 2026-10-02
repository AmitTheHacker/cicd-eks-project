# ============================================
# ECR REPOSITORY (Docker Images Storage)
# ============================================

resource "aws_ecr_repository" "app" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE" # Same tag se multiple images push kar sakte ho

  image_scanning_configuration {
    scan_on_push = true # Image push hote hi vulnerability scan hoga
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Lifecycle Policy: Purani images auto-delete karo (cost bachane ke liye)
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Sirf latest 10 images rakho"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}