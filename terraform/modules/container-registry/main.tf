resource "azurerm_container_registry" "acr" {
  name                = var.container-name
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location
  sku                 = var.container-sku-name
  admin_enabled       = true
}