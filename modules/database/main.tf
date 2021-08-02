
resource "azurerm_mssql_server" "ss-sqlserver" {
  name                         = "fastservicedb"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  version                      = "12.0"
  administrator_login          = "llopez7"
  administrator_login_password = var.ssadminpassword
  minimum_tls_version          = "1.2"

  tags = {
    "terraform-managed" = "true"
  }
}

resource "azurerm_mssql_database" "db-database" {
  name           = "FastServicedb"
  server_id      = azurerm_mssql_server.ss-sqlserver.id
  collation      = "Modern_Spanish_CI_AS"
  sku_name       = "Basic"
  max_size_gb    = 1
  zone_redundant = false

  tags = {
    "terraform-managed" = "true"
  }
}

resource "azurerm_storage_account" "sa-dbbackups" {
  name                     = var.server_name
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  allow_blob_public_access  = false
  enable_https_traffic_only = true

  tags = {
    "terraform-managed" = "true"
  }
}