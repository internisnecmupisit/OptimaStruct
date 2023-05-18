resource "azurerm_linux_web_app" "webapi" {
  name                = var.webapp-name
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  service_plan_id     = var.service-plan-id

  site_config {
    always_on                               = true
    # container_registry_use_managed_identity = false
    application_stack {
      docker_image     = "${var.acr-name}.azurecr.io/${var.image-tag}"
      docker_image_tag = "latest"
    }
    ip_restriction {
      action     = "Allow"
      virtual_network_subnet_id = var.allow-vnet
      name       = "AllowVNet"
      priority   = 100
    }
    # ip_restriction {
    #   action   = "Deny"
    #   ip_address = "0.0.0.0/0"
    #   name     = "DenyAll"
    #   priority = 200
    # }
    ip_restriction {
      action   = "Allow"
      ip_address = "0.0.0.0/0"
      name     = "AllowAll"
      priority = 200
    }
  }
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL = "https://${var.acr-name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = var.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = var.admin_password
  }
  # connection_string {
  #   name  = "Database"
  #   type  = "SQLServer"
  #   value = "Server=${var.sqlserver-name}.database.windows.net;Integrated Security=SSPI"
  # }
}

# resource "azurerm_network_interface" "webapi" {
#   name                = "nic-${azurerm_linux_web_app.webapi.name}"
#   location            = azurerm_linux_web_app.webapi.location
#   resource_group_name = azurerm_linux_web_app.webapi.resource_group_name

#   ip_configuration {
#     name                          = "ipconf-${azurerm_linux_web_app.webapi.name}"
#     subnet_id                     = var.subnet-id
#     private_ip_address_allocation = "Dynamic"
#   }
#   depends_on = [azurerm_private_endpoint.webapi]
# }

# resource "azurerm_private_endpoint" "webapi" {
#   name                = "pep-${azurerm_linux_web_app.webapi.name}"
#   location            = azurerm_linux_web_app.webapi.location
#   resource_group_name = azurerm_linux_web_app.webapi.resource_group_name

#   subnet_id                  = var.subnet-id
#   private_service_connection {
#     name                           = "psc-${azurerm_linux_web_app.webapi.name}"
#     subresource_names              = ["sites"]
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_linux_web_app.webapi.id
#   }
# }