# Generate - MySQL Password
resource "random_password" "mysql" {
  length           = 24
  min_special      = 4
  override_special = "!*()-_=+[]<>?"
}

# MySQL Server
resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-${var.name}"
  location               = var.location
  resource_group_name    = var.rg_name
  version                = "8.0.21"
  administrator_login    = "mysql"
  administrator_password = random_password.mysql.result
  sku_name               = "B_Standard_B1ms"
  tags                   = var.tags

  storage {
    auto_grow_enabled = true
    size_gb = 32
  }

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "database" {
  name      = var.db_name
  charset   = "UTF8"
  collation = "en_US.utf8"
  resource_group_name = var.rg_name
  server_name = azurerm_mysql_flexible_server.main.name
}

# MySQL Firewall - Azure
resource "azurerm_mysql_flexible_server_firewall_rule" "fw_azure_services" {
  name             = "azure_services"
  server_name        = azurerm_mysql_flexible_server.main.name
  resource_group_name = var.rg_name
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
