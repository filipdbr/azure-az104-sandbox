# set up an internal LB
resource "azurerm_lb" "app_lb" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # dynamic private IP allocation
  frontend_ip_configuration {
    name                          = "fe-ip-config-${var.name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# configure the backend pool
resource "azurerm_lb_backend_address_pool" "be_pool" {
  name            = "app-backend-pool"
  loadbalancer_id = azurerm_lb.app_lb.id
}

# configure the health probe
resource "azurerm_lb_probe" "internal_probe" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name            = "http-probe"
  port            = 80
  protocol        = "Tcp"
}

# set up a rule directing traffic to VMs in the app tier
resource "azurerm_lb_rule" "app_rule" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.app_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.app_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.internal_probe.id
  backend_address_pool_ids       = azurerm_lb_backend_address_pool.be_pool.inbound_nat_rules
}