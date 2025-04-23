resource "harvester_image" "opensuse-leap-156" {
  name      = "opensuse-leap-15.6"
  namespace = "harvester-public"

  display_name = "opensuse-leap-15.6"
  source_type  = "download"
  storage_class_name = harvester_storageclass.longhorn-single.name
  url          = "https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2"
  depends_on = [ harvester_storageclass.longhorn-single ]
}

resource "harvester_ssh_key" "keypair-jeroen" {
    name = "jeroen"
    namespace = "default"
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSE68VYUiwL5a8xcmv34RZ1OYnrEcRBe4NaeKpE/twU jeroen@hierynomus.com"
}

resource "harvester_ssh_key" "keypair-erin" {
    name = "erin-m2"
    namespace = "default"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrkMfTTDxPafXv+E1olBKCqu3ggaRGeitMaJ5iJHr588Bo2PcPY+xlM5iM1WITNBwUtdotxtIPVv25sijeEB4eCn4Sx/460FB9cbucGMUqZeeMZe++ibziT/5vyDQhIBwEpw3tm5qtd1rLJkdIbq6hyxbkH2lr8RKfEGA9CCCTFeX7CPHHsVx3KXoS2TDceVHEaMaNBSpT1wkUJ26WLnbjYIkeTI2tqWmS/zV2u8wE9hyWsKheXRL3P9Ams+n2t4UmjNb0Xs96hkjHbcl8Pa8dlrOOER9oINWblfbuJR28Q3vlPR/3yLC1JI9o/+Vq92aMRZiA2BMg+uC/vj18GnKwrSJQ1tEt4hnHxwTaMBjBhXuH6AJDL1LxwKMhP8iNHmke/VuIUcjtusRmpDGtVy/Jov506FAN9coWqg0DC7RojwvGaK8SSCHDV6XLZGXg5PuoyiagCRqGsp6Y5FUMtodNLEzvWe3yLS7gOLTEfoddZM9cn+u9jzQVgyqfjT9xUtc= erquill@Erins-MacBook-Pro-2.local"
}

resource "harvester_storageclass" "longhorn-single" {
    name = "longhorn-single"
    parameters = {
        "migratable"          = "true"
        "numberOfReplicas"    = "1"
        "staleReplicaTimeout" = "30"
    }

    volume_provisioner = "driver.longhorn.io"
    reclaim_policy      = "Delete"
    allow_volume_expansion = true
    volume_binding_mode   = "Immediate"
}

# The Harvester provider does not yet support the creation of an Untagged Network
resource "kubectl_manifest" "backbone-vlan" {
    yaml_body = file("${path.module}/manifests/backbone-vlan.yaml")
}

# The Harvester provider does not yet support the creation of a Cloud Init Template, only a secret for referencing from a VM
resource "kubectl_manifest" "cloudinit-k3s" {
    yaml_body = templatefile("${path.module}/manifests/cloudinit-k3s.yaml", {
        "domain_suffix" = var.domain_suffix
    })
}
