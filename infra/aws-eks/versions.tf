terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.30" }
    local = { source = "hashicorp/local", version = "~> 2.5" }
  }
  backend "s3" {}
}
provider "aws" { region = var.region }
