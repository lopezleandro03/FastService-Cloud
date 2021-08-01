# Configure the Azure provider
terraform {
  backend "remote" {
    organization = "FastService"

    workspaces {
      name = "FastService-Cloud"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.70.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  tenant_id = var.tenant_id
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id

  features {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "fastservice-app"
  location = "brazilsouth"

  tags = {
    "terraform-managed" = "true"
  }
}

resource "azurerm_app_service_plan" "asp-webapp" {
  name                = "basic-serviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
    capacity = 0
  }

  kind = "app"
  per_site_scaling = "false"

  tags = {
    "terraform-managed" = "true"
  }
}

resource "azurerm_app_service" "as-webapp" {
  name                = "fastserviceweb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp-webapp.id

  enabled = "true"
  https_only = "true"
  client_affinity_enabled = "true"

  site_config {
    dotnet_framework_version = "v4.0"
    managed_pipeline_mode = "Integrated"
    use_32_bit_worker_process = "true"
    websockets_enabled = "false"
    always_on = "false"
  }

  tags = {
    "terraform-managed" = "true"
  }
}

resource "azurerm_mssql_server" "ss-sqlserver" {
  name                         = "fastservicedb"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
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
  name                     = "fastservicebackups"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  min_tls_version = "TLS1_2"

  allow_blob_public_access = false
  enable_https_traffic_only = true
  
  tags = {
    "terraform-managed" = "true"
  }
}