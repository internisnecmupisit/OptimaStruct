resource "azurerm_service_plan" "service-plan" {
  name                = var.service-plan-name
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  os_type             = var.service-plan-os_type
  sku_name            = var.service-plan-sku_name
}