output "web_servers_ips" {
  value = azurerm_orchestrated_virtual_machine_scale_set.web_servers.id
}