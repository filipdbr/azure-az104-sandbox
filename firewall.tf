resource "azurerm_public_ip" "firewall" {
  name                = "pip-prod-pl-firewall"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  sku                 = "Standard"          # standard ip is necessary for a firewall
  tags                = local.shared_tags
}

resource "azurerm_firewall" "default" {
  name                = "firewall-prod-pl-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"

  management_ip_configuration {
    name = "firewall-prod-pl-hub-ip-config"
    subnet_id = module.hub_vnet.subnets["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
  
  tags = local.shared_tags
}