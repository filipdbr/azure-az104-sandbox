resource "azurerm_network_security_group" "agg_gateway" {
  name = "nsg-prod-pl-spoke-appgw"
  location = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "AllowGatewayManager"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = local.shared_tags
}

resource "azurerm_subnet_network_security_group_association" "app_gateway" {
  subnet_id                 = module.spoke_vnet.subnets["snet-prod-pl-appgw"].id
  network_security_group_id = azurerm_network_security_group.agg_gateway.id
}