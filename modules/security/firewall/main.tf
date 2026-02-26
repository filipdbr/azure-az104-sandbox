resource "azurerm_public_ip" "firewall" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard" # standard ip is necessary for a firewall
  tags                = var.tags
}

resource "azurerm_firewall" "default" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "${var.name}-ip-config"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  tags = var.tags
}