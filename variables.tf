variable "location" {
  type        = string
  description = "main region for all Azure resources"
}

variable "vmss_size" {
  type        = string
  description = "our default SKU - great value for money and perfect for testing purposes"
}

variable "storage_account_type" {
  type        = string
  description = "you can define your own value, however I recemmend keeping Standard_LRS"
}

variable "app_server_size" {
  type = string
}

variable "shared_key_vpn" {
  type        = string
  description = "shared key defined by user"
  sensitive   = true
}

variable "office_city" {
  type = string
}

variable "pip_office" {
  type        = string
  description = "public IP of the office"
}

variable "office_address_space" {
  type        = list(string)
  description = "address space of your office"
  default     = []
}

# logins

variable "login_app_servers" {
  type        = string
  description = "app servers admin username"
}

variable "login_web_servers" {
  type        = string
  description = "web servers admin username"
}

variable "login_db_admin" {
  type        = string
  description = "database admin username"
}

# passwords
variable "pwd_web_servers" {
  type        = string
  description = "password to web-servers"
  sensitive   = true
}

variable "pwd_app_servers" {
  type        = string
  description = "password to app-servers"
  sensitive   = true
}

variable "pwd_db" {
  type        = string
  description = "password to the database"
  sensitive   = true
}