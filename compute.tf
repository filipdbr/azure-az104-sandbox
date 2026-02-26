module "web_servers" {
    source = "./modules/compute/vmss"
    name = "vmss-prod-pl-web"
    location = azurerm_resource_group.spoke.location
    resource_group_name = azurerm_resource_group.spoke.name
    sku_name = var.sku
    admin_pwd = var.vmss_admin_pwd
    custom_data = filebase64("${path.module}/scripts/web_config.sh")
    storage_type = var.storage_account_type
    subnet_id = module.spoke_vnet.subnets["snet-prod-pl-web"].id
    tags = local.shared_tags
}