resource "azurerm_postgresql_server" "psqlserver" {
  name                             = var.psql-name
  location                         = var.resource-group-location
  resource_group_name              = var.resource-group-name

  administrator_login              = var.administrator-login
  administrator_login_password     = var.administrator-login-password

  sku_name                         = var.sku-name
  version                          = var.psql-version
  storage_mb                       = var.storage-mb
  backup_retention_days            = var.backup-retention-days

  geo_redundant_backup_enabled     = var.geo-redundant-backup-enabled
  auto_grow_enabled                = var.auto-grow-enabled

  public_network_access_enabled    = var.public-network-access
  ssl_enforcement_enabled          = var.ssl-enforcement-enabled
  ssl_minimal_tls_version_enforced = var.tls-version-enforced
}