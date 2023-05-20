resource "azurerm_app_service_virtual_network_swift_connection" "asn-webapi" {
  app_service_id = var.app-service-id
  subnet_id      = var.subnet-id
}