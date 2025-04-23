# # Rancher resources

# # Initialize Rancher server
# resource "rancher2_bootstrap" "admin" {
#   depends_on = [
#     helm_release.rancher_server
#   ]

#   password  = var.admin_password
#   # telemetry = true
# }
