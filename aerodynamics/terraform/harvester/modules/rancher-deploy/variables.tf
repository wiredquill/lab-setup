# Variables for rancher deploy module

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.17.1"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format v0.0.0)"
  default     = "2.11.0-hotfix-42a5.1"
}

# Required
variable "admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

variable "rancher_helm_repository" {
  type        = string
  description = "The helm repository, where the Rancher helm chart is installed from"
  default     = "https://releases.rancher.com/server-charts/latest"
}

variable "kubeconfig" {
  type        = string
  description = "Path to the KubeConfig config file"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token for cert-manager"
  sensitive = true
}

variable "letsencrypt_email" {
  type        = string
  description = "Email address for Let's Encrypt"
}

variable "rancher_server_dns" {
  type        = string
  description = "DNS name for the Rancher server"
}
