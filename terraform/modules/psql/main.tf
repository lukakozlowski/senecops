# Generate - PSQL Password
resource "random_password" "postgresql" {
  length           = 24
  min_special      = 4
  override_special = "!*()-_=+[]<>?"
}

# PSQL Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "psql-${var.name}"
  location               = var.location
  resource_group_name    = var.rg_name
  version                = "16"
  administrator_login    = "postgres"
  administrator_password = random_password.postgresql.result
  storage_mb             = 32768
  storage_tier           = "P10"
  sku_name               = "B_Standard_B1ms" #TODO: had some issues on my internal subscription and limitation especially on specified region, it could be "B1ms" - cheapest
  auto_grow_enabled      = true
  tags                   = var.tags

  identity {
    type         = "SystemAssigned"
    identity_ids = []
  }

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

# PSQL Database
resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# PSQL Configuration
resource "azurerm_postgresql_flexible_server_configuration" "tls_off" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "off"
}

# PSQL Firewall - Azure
resource "azurerm_postgresql_flexible_server_firewall_rule" "fw_azure_services" {
  name             = "azure_services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
