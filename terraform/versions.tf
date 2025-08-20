terraform {
  required_version = ">= 1.8"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.35.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.5.2"
    }
  }
}
