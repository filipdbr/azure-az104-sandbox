module "database" {
  source              = "./modules/database"
  server_name         = "sql-server-prod-pl"
  db_name             = "sql-db-prod-pl"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  admin_login         = var.db_admin_login
  admin_pwd           = var.db_pwd
  db_subnet_id        = module.spoke_vnet.subnets["snet-prod-pl-db"].id
  vnet_id             = module.spoke_vnet.vnet_id
  tags = merge(local.shared_tags, {
    type = "database"
  })
}