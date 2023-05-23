resource "azurerm_postgresql_database" "dbpsql" {
  name                = var.db-name
  resource_group_name = var.resource-group-name
  server_name         = var.server-name
  charset             = var.charset
  collation           = var.collation
}