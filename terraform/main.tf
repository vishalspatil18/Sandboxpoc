provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-data-project"
  location = "Germany West Central"
}

resource "azurerm_storage_account" "storage" {
  name                     = "storageacct12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_eventhub_namespace" "eh_ns" {
  name                = "ehns12345"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

resource "azurerm_eventhub" "eventhub" {
  name                = "data-eventhub"
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
}

resource "azurerm_function_app" "function_app" {
  name                = "function-app-12345"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_name = azurerm_storage_account.storage.name
  os_type             = "Linux"
  app_service_plan_id = azurerm_app_service_plan.plan.id
}

resource "azurerm_kusto_cluster" "adx_cluster" {
  name                = "adx-cluster-12345"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku {
    name     = "Standard_D11_v2"
    capacity = 2
  }
}

resource "azurerm_kusto_database" "adx_db" {
  name                = "adx-database"
  resource_group_name = azurerm_resource_group.rg.name
  cluster_name        = azurerm_kusto_cluster.adx_cluster.name
}
