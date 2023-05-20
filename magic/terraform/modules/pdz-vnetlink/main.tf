resource "azurerm_private_dns_zone_virtual_network_link" "pdzvnetlink" {
  name                  = var.pdzvnetlink-name
  private_dns_zone_name = var.private-dns-zone-name
  virtual_network_id    = var.virtual-network-id
  resource_group_name   = var.resource-group-name
}