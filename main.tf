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
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id

  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location

  tags = {
    "terraform-managed" = "true"
  }
}

module "webapp" {
  source = "./modules/webapp"

  resource_group = azurerm_resource_group.rg
  webapp_name    = var.webapp_name
}

module "database" {
  source = "./modules/database"

  resource_group  = azurerm_resource_group.rg
  server_name     = var.server_name
  backup_storage_name = var.backup_storage_name
  ssadminpassword = var.ssadminpassword
}
