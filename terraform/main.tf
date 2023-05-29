terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "configuration" {
  source = "./configuration"

  project-name = "__projectname__"
  environment = "__environment__"
  rgname = "__rgterraform__"
}

module "vnet" {
  source = "./modules/virtual-network"

  virturl-network-name    = "vnet-${module.configuration.project-name}-${module.configuration.environment}"
  resource-group-name     = module.configuration.rgname
  resource-group-location = module.configuration.location
  address-space           = "10.0.0.0/16"
}

module "asn-public" {
  source = "./modules/subnet-public"

  subnet-name          = "snet-${module.configuration.project-name}-public-${module.configuration.environment}"
  resource-group-name  = module.configuration.rgname
  virtual-network-name = module.vnet.name
  address-prefixes     = "10.0.1.0/24"
  delegation-name      = "AppServiceDelegationPublic"
  service-delegation-name = "Microsoft.Web/serverFarms"
  actions = "Microsoft.Network/virtualNetworks/subnets/action"
}

module "asn-private" {
  source = "./modules/subnet-private"

  subnet-name          = "snet-${module.configuration.project-name}-private-${module.configuration.environment}"
  resource-group-name  = module.configuration.rgname
  virtual-network-name = module.vnet.name
  address-prefixes     = "10.0.2.0/24"
  delegation-name      = "AppServiceDelegation"
  service-delegation-name = "Microsoft.Web/serverFarms"
  actions = "Microsoft.Network/virtualNetworks/subnets/action"
}

locals {
  backend_address_pool_name      = "${module.vnet.name}-beap"
  frontend_port_name             = "${module.vnet.name}-feport"
  frontend_ip_configuration_name = "${module.vnet.name}-feip"
  http_setting_name              = "${module.vnet.name}-be-htst"
  listener_name                  = "${module.vnet.name}-httplstn"
  request_routing_rule_name      = "${module.vnet.name}-rqrt"
}

module "container-registry" {
  source = "./modules/container-registry"

  container-name          = "__acrname__"
  resource-group-name     = module.configuration.rgname
  resource-group-location = module.configuration.location
  container-sku-name      = "Standard"
}

module "service-plan" {
  source = "./modules/service-plan"

  service-plan-name       = "asp-${module.configuration.project-name}-${module.configuration.environment}"
  service-plan-os_type    = "Linux"
  service-plan-sku_name   = "B3"
  resource-group-name     = module.configuration.rgname
  resource-group-location = module.configuration.location
}

module "webapp" {
  source = "./modules/webapp"

  webapp-name             = "ase-app-${module.configuration.project-name}-${module.configuration.environment}"
  resource-group-name     = module.configuration.rgname
  resource-group-location = module.configuration.location
  service-plan-id         = module.service-plan.id
  acr-name                = module.container-registry.name
  image-tag               = "app"
  admin_username          = module.container-registry.admin_username
  admin_password          = module.container-registry.admin_password
}

module "webapi" {
  source = "./modules/webapi"

  webapp-name             = "ase-api-${module.configuration.project-name}-${module.configuration.environment}"
  resource-group-name     = module.configuration.rgname
  resource-group-location = module.configuration.location
  service-plan-id         = module.service-plan.id
  acr-name                = module.container-registry.name
  image-tag               = "api"
  subnet-id               = module.asn-private.id
  allow-vnet              = module.asn-private.id
  admin_username          = module.container-registry.admin_username
  admin_password          = module.container-registry.admin_password
}

module "webhook-api" {
  source = "./modules/webhook"

  registry-name = module.container-registry.name
  name = "webhook${module.configuration.project-name}api${module.configuration.environment}"
  location = module.configuration.location
  service-uri = module.webapi.webhook-uri
  rg-name = module.configuration.rgname
}

module "webhook-app" {
  source = "./modules/webhook"

  registry-name = module.container-registry.name
  name = "webhook${module.configuration.project-name}app${module.configuration.environment}"
  location = module.configuration.location
  service-uri = module.webapp.webhook-uri
  rg-name = module.configuration.rgname
}