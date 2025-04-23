module "base" {
    source = "./modules/base"
    domain_suffix = var.domain_suffix
}

resource "harvester_virtualmachine" "control-tower" {
    name = "control-tower"
    namespace = "default"

    cpu = 2
    memory = "6Gi"
    hostname = "control-tower"
    efi = true
    secure_boot = false

    disk {
        name = "disk-0"
        bus = "virtio"
        type = "disk"
        size = "100Gi"
        image = module.base.opensuse-image
        boot_order = 1
        auto_delete = true
    }

    input {
        name = "tablet"
        type = "tablet"
        bus  = "usb"
    }

    network_interface {
        name = "default"
        network_name = "default/backbone-vlan"
        wait_for_lease = true
    }

    cloudinit {
        user_data = templatefile("${path.module}/cloudinit/control-tower.yaml", {
            "domain_suffix" = var.domain_suffix
        })
    }
}
