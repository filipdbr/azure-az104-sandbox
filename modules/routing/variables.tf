variable "route_table_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_private_ip" {
  type = string
}

variable "subnets_ids" {
  type = map(string)
  default = { }
}


variable "tags" {
  type = map(string)
  default = { }
}