# resource group for hub
resource "azurerm_resource_group" "hub" {
  name     = "rg-prod-pl-hub"
  location = var.location
  tags     = local.shared_tags
}

# resource group for spoke
resource "azurerm_resource_group" "spoke" {
  name     = "rg-prod-pl-spoke"
  location = var.location
  tags     = local.shared_tags
}