resource "azurerm_private_dns_zone" "pdz" {
  name                = var.pdz-name
  resource_group_name = var.resource-group-name
}