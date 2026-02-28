output "app_vm_private_ips" {
  value = {
    for server_name, private_ip in var.names : "vm-app-${name}" => azurerm_network_interface.app[*].private_ip
  }
  description = "map of private IPs associated with app servers"
}