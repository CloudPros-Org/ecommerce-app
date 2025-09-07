terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google      = { source = "hashicorp/google", version = "~> 5.30" }
    google-beta = { source = "hashicorp/google-beta", version = "~> 5.30" }
    kubernetes  = { source = "hashicorp/kubernetes", version = "~> 2.30" }
    local       = { source = "hashicorp/local", version = "~> 2.5" }
  }
  backend "gcs" {}
}
provider "google" { project = var.project_id, region = var.region }
provider "google-beta" { project = var.project_id, region = var.region }
