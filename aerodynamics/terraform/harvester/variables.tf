variable "kubeconfig_path" {
    description = "Path to the Harvester KubeConfig config file"
    type        = string
    default     = ""
}

variable "kubeconfig_context" {
    description = "KubeConfig context to use"
    type        = string
    default     = ""
}

variable "domain_suffix" {
    description = "Domain suffix domain names"
    type        = string
    default     = "lab.geeko.me"
}

variable "ssh_username" {
    type = string
    default = ""
}

variable "ssh_private_key" {
    type = string
    default = ""
}

variable "cloudflare_api_token" {
    type = string
    default = ""
    sensitive = true
}

variable "letsencrypt_email" {
  type = string
  default = ""
}
