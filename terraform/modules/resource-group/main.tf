resource "azurerm_resource_group" "resource-group" {
  name     = var.resource-group-name
  location = var.resource-group-location
}