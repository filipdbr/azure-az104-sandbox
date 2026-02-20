locals {
  rg_tags = {
    "Environment" = "Prod"
  }
}

# resource group for hub
resource "azurerm_resource_group" "rg-prod-pl-hub" {
  name = "rg-prod-pl-hub"
  location = var.location
  tags = local.rg_tags
}

# resource group for spoke
resource "azurerm_resource_group" "rg-prod-pl-hub" {
  name = "rg-prod-pl-hub"
  location = var.location
  tags = local.rg_tags
}