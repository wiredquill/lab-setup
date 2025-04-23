variable "kubeconfig_path" {
    description = "Path to the Harvester KubeConfig config file"
    type        = string
    default     = "~/.kube/engine-bay.yaml"
}

variable "kubeconfig_context" {
    description = "KubeConfig context to use"
    type        = string
    default     = "engine-bay"
}

variable "domain_suffix" {
    description = "Domain suffix domain names"
    type        = string
    default     = "lab.geeko.me"
}
