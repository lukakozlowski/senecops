output "password" {
  value     = random_password.mysql.result
  sensitive = true
}

output "user" {
  value = azurerm_mysql_flexible_server.main.administrator_login
}

output "host" {
  value = azurerm_mysql_flexible_server.main.fqdn
}

output "db_name" {
  value = azurerm_mysql_flexible_database.database.name
}

output "port" {
  value = 3306
}
