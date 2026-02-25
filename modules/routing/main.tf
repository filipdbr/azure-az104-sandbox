# create a route table
resource "azurerm_route_table" "defalut" {
  name                = var.route_table_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# create a rule for the route table: all outbound traffic to the internet is to go throught the firewall
resource "azurerm_route" "to_firewall" {
  name                   = "route-to-fw-prod-pl"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.defalut.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

# associate the table with web and app subnets
resource "azurerm_subnet_route_table_association" "defalut" {
    for_each = var.subnets_ids
    subnet_id = each.value
    route_table_id = azurerm_route_table.defalut.id
}