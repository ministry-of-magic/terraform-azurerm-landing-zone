locals {
  location = {
    "australiaeast" = "aue"
  }

  suffix = lower(format("%s-%s-%s", local.location[var.location], var.environment, var.project))
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = format("rg-%s", local.suffix)
  location = var.location

  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  name                = format("rg-%s-core", local.suffix)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = ["Create", "Delete", "Get", "List", "Update"]
    key_permissions         = ["Create", "Delete", "Get", "List", "Update"]
    secret_permissions      = ["Delete", "Get", "List", "Set"]
  }

  tags = var.tags
}

resource "azurerm_storage_account" "this" {
  name                     = format("sa%score", replace(local.suffix, "-", ""))
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = format("law-%s", local.suffix)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
