resource "azurerm_subnet_network_security_group_association" "asnnsgassociate" {
  subnet_id                 = var.subnet-id
  network_security_group_id = var.network-security-group-id
}