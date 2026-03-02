resource "azurerm_mssql_server" "default" {
  name = var.server_name
  resource_group_name = var.resource_group_name
  location = var.location
  version = "12.0"
  administrator_login = var.admin_login
  administrator_login_password = var.admin_pwd
  minimum_tls_version = "1.2"
  tags = var.tags
}

resource "azurerm_mssql_database" "default" {
  name = var.db_name
  server_id = azurerm_mssql_server.default.id
  collation = var.collation
  license_type = "BasePrice"
  max_size_gb = 1
  sku_name = "Basic"
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name = "AllowAzureServices"
  server_id = azurerm_mssql_server.default.id
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}