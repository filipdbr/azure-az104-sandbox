# create a public IP to be used by the firewall
resource "azurerm_public_ip" "firewall" {
  name                = "pip-prod-pl-firewall"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  sku                 = "Standard" # standard ip is necessary for a firewall
  tags                = local.shared_tags
}

# create the firewall
resource "azurerm_firewall" "default" {
  name                = "firewall-prod-pl-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "firewall-prod-pl-hub-ip-config"
    subnet_id            = module.hub_vnet.subnets["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  tags = local.shared_tags
}

# create a route table for spoke
resource "azurerm_route_table" "spoke" {
  name                = "rt-prod-pl-spoke"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  tags                = local.shared_tags
}

# create a rule for the route table: all outbound traffic to the internet is to go throught the firewall
resource "azurerm_route" "to_firewall" {
  name                   = "route-to-fw-prod-pl"
  resource_group_name    = azurerm_resource_group.spoke.name
  route_table_name       = azurerm_route_table.spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.default.ip_configuration[0].private_ip_address
}

# associate the table with web and db subnets
resource "azurerm_subnet_route_table_association" "web" {
  subnet_id = module.spoke_vnet.subnets["snet-prod-pl-web"].id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_subnet_route_table_association" "db" {
  subnet_id = module.spoke_vnet.subnets["snet-prod-pl-db"].id
  route_table_id = azurerm_route_table.spoke.id
}