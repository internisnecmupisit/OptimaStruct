resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg-name
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name

  security_rule {
    name                       = var.sr-name
    priority                   = var.priority
    direction                  = var.direction
    access                     = var.access
    protocol                   = var.protocol
    source_port_range          = var.source-port-range
    destination_port_range     = var.destination-port-range
    source_address_prefix      = var.source-address-prefix
    destination_address_prefix = var.destination-address-prefix
  }
}