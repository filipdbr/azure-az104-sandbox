# NSG for app gateway subnet
resource "azurerm_network_security_group" "agg_gateway" {
  name                = "nsg-prod-pl-spoke-appgw"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "AllowGatewayManager"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = local.shared_tags
}

resource "azurerm_subnet_network_security_group_association" "app_gateway" {
  subnet_id                 = module.spoke_vnet.subnets["snet-prod-pl-appgw"].id
  network_security_group_id = azurerm_network_security_group.agg_gateway.id
}

# NSG for web subnet in spoke vnet
resource "azurerm_network_security_group" "web" {
  name                = "nsg-prod-pl-spoke-web"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = module.spoke_vnet.subnets["snet-prod-pl-appgw"].address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = module.spoke_vnet.subnets["snet-prod-pl-web"].id
  network_security_group_id = azurerm_network_security_group.web.id
}

# NSG for app subnet
resource "azurerm_network_security_group" "app" {
  name                = "nsg-prod-pl-spoke-app"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "AllowHTTPandHTTPSInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = module.spoke_vnet.subnets["snet-prod-pl-app"].address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = module.spoke_vnet.subnets["snet-prod-pl-app"].id
  network_security_group_id = azurerm_network_security_group.app.id
}

# NSG for db tier / subnet
resource "azurerm_network_security_group" "db" {
  name                = "nsg-prod-pl-spoke-db"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "AllowSQLnbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = module.spoke_vnet.subnets["snet-prod-pl-app"].address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = module.spoke_vnet.subnets["snet-prod-pl-app"].id
  network_security_group_id = azurerm_network_security_group.app.id
}

# NSG for Bastion Subnet
resource "azurerm_network_security_group" "bastion" {
  name                = "nsg-prod-pl-hub-bastion"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  # Inbound

  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowGatewayManagerInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager" # service tag
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer" # service tag
    destination_address_prefix = "*"
  }

  # Outbound

  security_rule {
    name                       = "AllowSSHRDPOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork" # service tag
  }

  security_rule {
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

  tags = local.shared_tags
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = module.hub_vnet.subnets["AzureBastionSubnet"].id
  network_security_group_id = azurerm_network_security_group.bastion.id
}