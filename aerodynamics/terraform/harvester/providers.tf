terraform {
  required_version = ">= 0.13"
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.7"
    }
    kubectl = {
        source  = "gavinbunney/kubectl"
        version = ">= 1.7.0"
    }
  }
}

provider "harvester" {

  # Path to kubeconfig file
}

provider "kubectl" {
  config_path = var.kubeconfig_path
  config_context = var.kubeconfig_context
  load_config_file = true
  # Path to kubeconfig file
}
