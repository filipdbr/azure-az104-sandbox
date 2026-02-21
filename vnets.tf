# vnet for hub
resource "azurerm_virtual_network" "hub" {
  name = "vnet-prod-pl-hub"
  location = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space = ["10.1.0.0/16"]
  tags = local.shared_tags
}

# vnet for spoke
resource "azurerm_virtual_network" "spoke" {
  name = "vnet-prod-pl-spoke"
  location = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space = ["10.2.0.0/16"]
  tags = local.shared_tags
}