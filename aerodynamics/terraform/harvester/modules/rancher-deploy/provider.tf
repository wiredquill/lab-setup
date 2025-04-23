terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 3.2.0"
    }
    kubectl = {
        source  = "gavinbunney/kubectl"
        version = ">= 1.7.0"
    }

  }
  required_version = ">= 1.0.0"
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}


provider "kubectl" {
  config_path = var.kubeconfig
  load_config_file = true
  # Path to kubeconfig file
}


# provider "rancher2" {
#   alias = "admin"

#   api_url  = local.rancher_url
#   insecure = true
#   # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
#   token_key = module.rancher-deploy.rancher_bootstrap_token
#   timeout   = "300s"
# }
