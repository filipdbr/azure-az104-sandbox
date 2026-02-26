# set up firewall
module "firewall" {
  source              = "./modules/security/firewall"
  name                = "firewall-prod-pl-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  pip_name            = "pip-prod-pl-firewall"
  subnet_id           = module.hub_vnet.subnets["AzureFirewallSubnet"].id
  tags                = local.shared_tags
}

# NSG for app gateway subnet
module "nsg_app_gateway" {
  source = "./modules/security/nsg"
  name = "nsg-prod-pl-spoke-appgw"
  location = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id = module.spoke_vnet.subnets["snet-prod-pl-appgw"].id

  security_rules = [{
    name                       = "AllowGatewayManager"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"    
  },
  {
    name                       = "AllowHTTPInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"    
  }]

  tags = local.shared_tags
}

# NSG for web subnet in spoke vnet
module "nsg_web" {
  source = "./modules/security/nsg"
  name = "nsg-prod-pl-spoke-web"
  location = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id = module.spoke_vnet.subnets["snet-prod-pl-web"].id

  security_rules = [{
    name                       = "AllowHTTPInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = module.spoke_vnet.subnets["snet-prod-pl-appgw"].address_prefixes[0]
    destination_address_prefix = "*"    
  }]

  tags = local.shared_tags
}

# NSG for app subnet
module "nsg_app" {
  source = "./modules/security/nsg"
  name = "nsg-prod-pl-spoke-app"
  location = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id = module.spoke_vnet.subnets["snet-prod-pl-app"].id

  security_rules = [{
    name                       = "AllowHTTPandHTTPSInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = module.spoke_vnet.subnets["snet-prod-pl-app"].address_prefixes[0]
    destination_address_prefix = "*"  
  }]

  tags = local.shared_tags
}

# NSG for db tier / subnet
module "nsg_db" {
  source = "./modules/security/nsg"
  name = "nsg-prod-pl-spoke-db"
  location = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id = module.spoke_vnet.subnets["snet-prod-pl-db"].id

  security_rules = [{
    name                       = "AllowSQLnbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = module.spoke_vnet.subnets["snet-prod-pl-app"].address_prefixes[0]
    destination_address_prefix = "*"
  }]

  tags = local.shared_tags
}

# NSG for Bastion Subnet
module "nsg_bastion" {
  source = "./modules/security/nsg"
  name = "nsg-prod-pl-hub-bastion"
  location = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  subnet_id = module.hub_vnet.subnets["AzureBastionSubnet"].id

  security_rules = [
    # inbound rules
    {
      name                       = "AllowHTTPSInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowGatewayManagerInbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager" # service tag
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer" # service tag
      destination_address_prefix = "*"      
    },
    # outbound rules
    {
      name                       = "AllowSSHRDPOutbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "3389"]
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork" # service tag      
    },
    {
      name                       = "AllowAzureCloudOutbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud" # service tag      
    }
    ]

  tags = local.shared_tags
}