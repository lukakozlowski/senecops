# terraform {
#   backend "azurerm" {
#     resource_group_name  = "xyz"
#     storage_account_name = "xyz"
#     container_name       = "xyz"
#     key                  = "xyz.tfstate"
#     subscription_id      = "xyz-xyz-xyz-xyz"
#   }
# }

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.33.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "=2.17.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.37.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "=5.100.0"
    }
  }
}

provider "azurerm" {
  # skip_provider_registration = true
  features {}
  # client_id       = var.az_client_id
  # client_secret   = var.az_client_secret
  tenant_id       = var.az_tenant_id
  subscription_id = var.az_subscription_id
}

provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_access_key_secret
  region     = "eu-central-1"
}

provider "helm" {
  kubernetes {
    host                   = module.aks.aks.kube_config.0.host
    client_certificate     = base64decode(module.aks.aks.kube_config.0.client_certificate)
    client_key             = base64decode(module.aks.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.aks.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = module.aks.aks.kube_config.0.host
  client_certificate     = base64decode(module.aks.aks.kube_config.0.client_certificate)
  client_key             = base64decode(module.aks.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.aks.kube_config.0.cluster_ca_certificate)
}
