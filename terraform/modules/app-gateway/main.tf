resource "azurerm_application_gateway" "appgateway" {
  name                = var.gw-name
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location

  sku {
    name     = var.sku-name
    tier     = var.sku-tier
    capacity = var.sku-capacity
  }

  enable_http2        = true

  gateway_ip_configuration {
    name      = var.gw-ip-config-name
    subnet_id = var.subnet-frontend-id
  }

  frontend_port {
    name = var.frontend-port-name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend-ip-config-name
    public_ip_address_id = var.public-ip-address-id
  }

  backend_address_pool {
    name = var.backend-address-pool
  }

  backend_http_settings {
    name                  = var.backend-http-settings
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = var.http-listener-name
    frontend_ip_configuration_name = var.front-ip-config-name
    frontend_port_name             = var.frontend-port-name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request-routing-rule
    rule_type                  = "Basic"
    priority                   = 25
    http_listener_name         = var.http-listener-name
    backend_address_pool_name  = var.backend-address-pool
    backend_http_settings_name = var.backend-http-settings
  }
}