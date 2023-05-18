resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp-name
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  service_plan_id     = var.service-plan-id
  
  site_config {
    always_on = true
    # container_registry_use_managed_identity = false
    application_stack {
      docker_image     = "${var.acr-name}.azurecr.io/${var.image-tag}"
      docker_image_tag = "latest"
    }
  }
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL = "https://${var.acr-name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = var.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = var.admin_password
  }
}