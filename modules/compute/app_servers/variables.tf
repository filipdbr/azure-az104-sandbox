variable "names" {
  type    = list(string)
  default = []
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "linuxadmin"
}

variable "admin_pwd" {
  type      = string
  sensitive = true
}

# cheapest solution by default
variable "os_disk" {
  type = map(string)
  default = {
    "caching"              = "ReadWrite"
    "storage_account_type" = "Standard_LRS"
  }
}

# we can get other images by using this command: az vm image list --output table
variable "source_image_reference" {
  type = map(string)
  default = {
    "publisher" = "Canonical"
    "offer"     = "0001-com-ubuntu-server-jammy"
    "sku"       = "22_04-lts"
    "version"   = "latest"
  }
}