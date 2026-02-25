resource "azurerm_virtual_network_peering" "vnet1-to-vnet2" {
  name                      = "peer-${var.vnet1_name}-to-${var.vnet2_name}"
  resource_group_name       = var.vnet1_rg_name
  virtual_network_name      = var.vnet1_name
  remote_virtual_network_id = var.vnet2_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "vnet2-to-vnet1" {
  name                      = "peer-${var.vnet2_name}-to-${var.vnet1_name}"
  resource_group_name       = var.vnet2_rg_name
  virtual_network_name      = var.vnet2_name
  remote_virtual_network_id = var.vnet1_id
  allow_forwarded_traffic   = true
}