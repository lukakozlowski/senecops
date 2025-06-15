output "password" {
  value = random_password.postgresql.result
}

output "username" {
  value = azurerm_postgresql_flexible_server.main.administrator_login
}

output "host" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "db_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}
