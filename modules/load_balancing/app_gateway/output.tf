# backend address pull is a set by defult. Conversion to list in order to get the element using index.
output "app_gateway_backend_address_pool_id" {
  value = tolist(azurerm_application_gateway.web.backend_address_pool)[0].id
}