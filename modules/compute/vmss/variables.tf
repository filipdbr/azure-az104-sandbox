variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "platform_fault_domain_count" {
  type    = number
  default = 1 # 1 will be enough for test env, for a real prod env we should increase this number to min 2
}

variable "sku_name" {
  type    = string
  default = "value"
}

variable "admin_name" {
  type    = string
  default = "azureadmin"
}

variable "admin_pwd" {
  type      = string
  sensitive = true
}

variable "custom_data" {
  type    = string
  default = null
}

variable "storage_type" {
  type    = string
  default = null
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}