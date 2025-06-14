output "psql_password" {
  value = random_password.postgresql.result
}

output "psql_username" {
  value = azurerm_postgresql_flexible_server.main.administrator_login
}

output "psql_host" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "psql_db_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}
