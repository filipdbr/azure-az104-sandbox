output "public_ip_web_servers" {
  value       = "http://${module.app_gw.app_gateway_public_ip}"
  description = "Please use the link in order to see the website"
}

output "web_servers_admin_username" {
  value = "Web servers admin username: ${module.web_servers.admin_username}"
}

output "app_servers_admin_username" {
  value = module.app_servers.admin_username
}

output "db_admin_username" {
  value = "Database admin username: ${module.database.admin_username}"
}

output "database_endpoint" {
  description = "DNS address of the Azure SQL Server"
  value       = module.database.sql_fqdn
}