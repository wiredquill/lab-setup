variable "domain_suffix" {
    description = "Domain suffix domain names"
    type        = string
    default     = "lab.geeko.me"
}

variable "vmimages" {
    description = "List of images to be used in the Harvester cluster"
    type        = map(string)
    default     = {
        "opensuse-leap-15.6-nc" = "https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2"
    }
}

variable "ssh_keys" {
    description = "List of SSH keys to be imported in the Harvester cluster"
    type        = map(string)
    default     = {
        "jeroen" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSE68VYUiwL5a8xcmv34RZ1OYnrEcRBe4NaeKpE/twU jeroen@hierynomus.com"
        "erin-m2" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrkMfTTDxPafXv+E1olBKCqu3ggaRGeitMaJ5iJHr588Bo2PcPY+xlM5iM1WITNBwUtdotxtIPVv25sijeEB4eCn4Sx/460FB9cbucGMUqZeeMZe++ibziT/5vyDQhIBwEpw3tm5qtd1rLJkdIbq6hyxbkH2lr8RKfEGA9CCCTFeX7CPHHsVx3KXoS2TDceVHEaMaNBSpT1wkUJ26WLnbjYIkeTI2tqWmS/zV2u8wE9hyWsKheXRL3P9Ams+n2t4UmjNb0Xs96hkjHbcl8Pa8dlrOOER9oINWblfbuJR28Q3vlPR/3yLC1JI9o/+Vq92aMRZiA2BMg+uC/vj18GnKwrSJQ1tEt4hnHxwTaMBjBhXuH6AJDL1LxwKMhP8iNHmke/VuIUcjtusRmpDGtVy/Jov506FAN9coWqg0DC7RojwvGaK8SSCHDV6XLZGXg5PuoyiagCRqGsp6Y5FUMtodNLEzvWe3yLS7gOLTEfoddZM9cn+u9jzQVgyqfjT9xUtc= erquill@Erins-MacBook-Pro-2.local"
    }
}

variable "cloudinit_templates" {
    description = "List of CloudInit templates to be imported in the Harvester cluster"
    type        = list(string)
    default     = [
        "cloudinit-k3s.yaml"
    ]
}
