module "web_servers" {
  source              = "./modules/compute/web_servers"
  name                = "vmss-prod-pl-web"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  sku_name            = var.vmss_size

  # login data
  admin_name = var.login_web_servers
  admin_pwd  = var.pwd_web_servers

  custom_data                         = filebase64("${path.module}/scripts/web_config.sh")
  storage_type                        = var.storage_account_type
  subnet_id                           = module.spoke_vnet.subnets["snet-prod-pl-web"].id
  tags                                = local.shared_tags
  application_gateway_backend_pool_id = module.app_gw.backend_address_pool_id
}

module "app_servers" {
  source              = "./modules/compute/app_servers"
  names               = ["vm-prod-pl-app-01", "vm-prod-pl-app-02"]
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = module.spoke_vnet.subnets["snet-prod-pl-app"].id
  size                = var.app_server_size

  # login data
  admin_username = var.login_app_servers
  admin_pwd      = var.pwd_app_servers
  # would be possible to define os_disk and but I will go with default settings
  # default settings are to be found in moules/compute/app_servers
}