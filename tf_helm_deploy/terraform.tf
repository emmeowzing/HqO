terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }

    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "0.5.0"
    }
  }

  required_version = "1.0.2"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes-alpha" {
  config_path = "~/.kube/config"
}