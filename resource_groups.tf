locals {
  rg_tags = {
    "Environment" = "Prod"
  }
}

# resource group from hub
resource "azurerm_resource_group" "rg-prod-pl-hub" {
  name = "rg-prod-pl-hub"
  location = var.location
  tags = local.rg_tags
}

# resource group from spoke
resource "azurerm_resource_group" "rg-prod-pl-hub" {
  name = "rg-prod-pl-hub"
  location = var.location
  tags = local.rg_tags
}