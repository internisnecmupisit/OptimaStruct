resource "azurerm_container_registry_webhook" "webhook" {
  name                = var.name
  resource_group_name = var.rg-name
  registry_name       = var.registry-name
  location            = var.location

  service_uri = var.service-uri
  status      = "enabled"
  scope       = ""
  actions     = ["push"]
}
