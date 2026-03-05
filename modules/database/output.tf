output "admin_username" {
  value = azurerm_mssql_server.default.administrator_login
}

output "sql_fqdn" {
  value = azurerm_mssql_server.default.fully_qualified_domain_name
}