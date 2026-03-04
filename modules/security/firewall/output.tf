output "private_ip_address" {
  value = azurerm_firewall.default.ip_configuration[0].private_ip_address
}

output "policy_id" {
  value       = azurerm_firewall_policy.default.id
}