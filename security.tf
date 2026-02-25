# set up firewall
module "firewall" {
    source = "./modules/firewall"
    name = "firewall-prod-pl-hub"
    resource_group_name = azurerm_resource_group.hub.name
    location = azurerm_resource_group.hub.location
    pip_name = "pip-prod-pl-firewall"
    subnet_id = module.hub_vnet.subnets["AzureFirewallSubnet"].id
    tags = local.shared_tags
}