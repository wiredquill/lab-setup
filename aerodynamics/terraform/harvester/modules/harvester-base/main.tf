resource "harvester_image" "vmimages" {
  for_each = var.vmimages
  name      = each.key
  namespace = "harvester-public"

  display_name = each.key
  source_type  = "download"
  storage_class_name = harvester_storageclass.longhorn-single.name
  url          = each.value
  depends_on = [ harvester_storageclass.longhorn-single ]
}

resource "harvester_ssh_key" "ssh_keys" {
    for_each = var.ssh_keys
    name = each.key
    namespace = "default"
    public_key = each.value
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
resource "kubectl_manifest" "cloudinit-templates" {
    for_each = toset(var.cloudinit_templates)
    yaml_body = templatefile("${path.module}/manifests/${each.value}", {
        "domain_suffix" = var.domain_suffix
    })
}
