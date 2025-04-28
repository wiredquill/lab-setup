terraform {
  required_version = ">= 0.13"
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
    kubectl = {
        source  = "gavinbunney/kubectl"
        version = ">= 1.7.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 3.2.0"
    }

  }
}

provider "harvester" {
  # Path to kubeconfig file
  kubeconfig = var.harvester_kubeconfig_path
  kubecontext = var.harvester_kubeconfig_context
}

provider "kubectl" {
  config_path = var.harvester_kubeconfig_path
  config_context = var.harvester_kubeconfig_context
  load_config_file = true
}
