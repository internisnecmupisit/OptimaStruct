output "id" {
  value = azurerm_subnet.asn-private.id
}

output "subnet-name" {
  value = azurerm_subnet.asn-private.name
}

output "address-prefixes" {
  value = azurerm_subnet.asn-private.address_prefixes
}