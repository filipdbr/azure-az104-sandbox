# order a vnet for hub
module "hub_vnet" {
  source              = "./modules/network"
  name                = "vnet-prod-pl-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
  tags                = local.shared_tags

  subnets = {
    "AzureBastionSubnet"  = "10.1.1.0/26"
    "GatewaySubnet"       = "10.1.2.0/27"
    "AzureFirewallSubnet" = "10.1.3.0/26"
  }
}

# order a vnet for spoke
module "spoke_vnet" {
  source              = "./modules/network"
  name                = "vnet-prod-pl-spoke"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = var.location
  address_space       = ["10.2.0.0/16"]
  tags                = local.shared_tags

  subnets = {
    "snet-prod-pl-appgw" = "10.2.1.0/24"
    "snet-prod-pl-web"   = "10.2.2.0/24"
    "snet-prod-pl-app"   = "10.2.3.0/24"
    "snet-prod-pl-db"    = "10.2.4.0/24"
  }
}

# set up peering
module "peering" {
  source = "./modules/peering"

  # vnet 1 : hub
  vnet1_name = module.hub_vnet.vnet_name
  vnet1_id = module.hub_vnet.vnet_id
  vnet1_rg_name = module.hub_vnet.rg

  # vnet 2 : spoke
  vnet2_name = module.spoke_vnet.vnet_name
  vnet2_id = module.spoke_vnet.vnet_id
  vnet2_rg_name = module.spoke_vnet.rg
}