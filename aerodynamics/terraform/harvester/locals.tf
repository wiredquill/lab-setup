resource "local_file" "control-tower_kubeconfig" {
  filename        = format("%s/control-tower.yaml", path.root)
  content         = ssh_resource.retrieve_control_tower_kubeconfig.result
  file_permission = "0600"
}
