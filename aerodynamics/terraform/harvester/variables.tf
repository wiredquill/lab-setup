variable "harvester_kubeconfig_path" {
    description = "Path to the Harvester KubeConfig config file"
    type        = string
    default     = ""
}

variable "harvester_kubeconfig_context" {
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

variable "vmimages" {
    description = "List of images to be imported in the Harvester cluster"
    type        = map(string)
    default     = {
        "opensuse-leap-15.6-nc" = "https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2"
        "ubuntu-24.04" = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    }
}
