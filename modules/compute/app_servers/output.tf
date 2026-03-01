output "app_vm_private_ips" {
  value = {
    for i, name in var.names : "vm-app-${name}" => azurerm_network_interface.app[i].private_ip_address
  }
  description = "map of private IPs associated with app servers"
}

output "app_nic_ids" {
  value = azurerm_network_interface.app[*].id
  description = "List of NICs for VMs in app tier"
}

output "app_ip_config_names" {
  value = azurerm_network_interface.app[*].ip_configuration[0].name
}

