
resource "azurerm_app_service_plan" "asp-webapp" {
  name                = "basic-serviceplan"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  sku {
    tier     = "Free"
    size     = "F1"
    capacity = 0
  }

  kind             = "app"
  per_site_scaling = "false"

  tags = {
    "terraform-managed" = "true"
  }
}

resource "azurerm_app_service" "as-webapp" {
  name                = var.webapp_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  app_service_plan_id = azurerm_app_service_plan.asp-webapp.id

  enabled                 = "true"
  https_only              = "true"
  client_affinity_enabled = "true"

  site_config {
    dotnet_framework_version  = "v4.0"
    managed_pipeline_mode     = "Integrated"
    use_32_bit_worker_process = "true"
    websockets_enabled        = "false"
    always_on                 = "false"
  }

  tags = {
    "terraform-managed" = "true"
  }
}