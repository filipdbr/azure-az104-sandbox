# create NICs for each VM
resource "azurerm_network_interface" "app" {
  count               = length(var.names)
  name                = "nic-${var.names[count.index]}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ip-config-${var.names[count.index]}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# create VMs
resource "azurerm_linux_virtual_machine" "app" {
  count                           = length(var.names)
  name                            = "vm-app-${var.names[count.index]}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_pwd
  disable_password_authentication = false

  # as we have 3 av zones in Poland (and most of the regions in general) this calculation will work for the most of the regions
  zone = tostring(count.index % 3) + 1

  network_interface_ids = [azurerm_network_interface.app[count.index].id]

  os_disk {
    caching              = var.os_disk["caching"]
    storage_account_type = var.os_disk["storage_account_type"]
  }

  source_image_reference {
    publisher = var.source_image_reference["publisher"]
    offer     = var.source_image_reference["offer"]
    sku       = var.source_image_reference["sku"]
    version   = var.source_image_reference["version"]
  }
}