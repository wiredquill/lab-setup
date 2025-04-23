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

resource "ssh_resource" "retrieve_control_tower_kubeconfig" {
  depends_on = [
    harvester_virtualmachine.control-tower
  ]
  host = "control-tower.${var.domain_suffix}"
  commands = [
    "sudo sed \"s/127.0.0.1/control-tower.${var.domain_suffix}/g\" /etc/rancher/k3s/k3s.yaml"
  ]
  user        = var.ssh_username
  private_key = file(var.ssh_private_key)
}

module "rancher-deploy" {
  source = "./modules/rancher-deploy"
  cloudflare_api_token = var.cloudflare_api_token
  letsencrypt_email = var.letsencrypt_email
  kubeconfig = local_file.control-tower_kubeconfig.filename
  admin_password = "!nfiniteP0wer"
  rancher_server_dns = "rancher.control-tower.${var.domain_suffix}"
}
