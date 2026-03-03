# resource group for hub
resource "azurerm_resource_group" "hub" {
  name     = "rg-hub"
  location = var.location
  tags     = local.shared_tags
}

# resource group for spoke
resource "azurerm_resource_group" "spoke" {
  name     = "rg-spoke"
  location = var.location
  tags     = local.shared_tags
}