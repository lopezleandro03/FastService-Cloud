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

module "webapp" {
  source = "./modules/webapp"

  resource_group = azurerm_resource_group.rg
  webapp_name = "fastserviceweb"
}

module "database" {
  source = "./modules/database"

  resource_group = azurerm_resource_group.rg
  server_name = "fastservicebackups"
  ssadminpassword = var.ssadminpassword
}
