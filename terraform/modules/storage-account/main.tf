resource "azurerm_storage_account" "storage-account" {
  name                     = var.storage-name
  resource_group_name      = var.resource-group-name
  location                 = var.resource-group-location
  account_tier             = var.account-tier
  account_replication_type = var.account-replication-type
}