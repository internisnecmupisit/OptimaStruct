resource "azurerm_public_ip" "publicip" {
  name                = var.pip-name
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location
  allocation_method   = var.allocation-method
  sku                 = var.sku-name
}