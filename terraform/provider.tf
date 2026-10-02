# ============================================
# PROVIDER CONFIGURATION
# ============================================
# Yeh batata hai ki hum AWS pe kaam kar rahe hain

terraform {
  required_version = ">= 1.5.0" # Terraform version minimum 1.5+ chahiye

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official AWS provider
      version = "~> 5.0"        # Version 5.x ka koi bhi
    }
  }
}

# AWS ko batao kaunsi region use karni hai
provider "aws" {
  region = var.aws_region # variables.tf se value aayegi
}