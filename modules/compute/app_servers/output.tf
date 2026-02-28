output "app_vm_private_ips" {
  value = {
    for i, name in var.names : "vm-app-${name}" => azurerm_network_interface.app[i].private_ip_address
  }
  description = "map of private IPs associated with app servers"
}