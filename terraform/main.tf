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

  project-name = __projectname__
  environment = __environment__
}

# module "resource-group" {
#   source = "./modules/resource-group"
#   resource-group-name     = ""__rgterraform__""
#   resource-group-location = module.configuration.location
# }

module "vnet" {
  source = "./modules/virtual-network"

  virturl-network-name    = "vnet-${module.configuration.project-name}-${module.configuration.environment}"
  resource-group-name     = "__rgterraform__"
  resource-group-location = module.configuration.location
  address-space           = "10.0.0.0/16"
}

module "asn-public" {
  source = "./modules/subnet-public"

  subnet-name          = "snet-${module.configuration.project-name}-public-${module.configuration.environment}"
  resource-group-name  = "__rgterraform__"
  virtual-network-name = module.vnet.name
  address-prefixes     = "10.0.1.0/24"
  delegation-name      = "AppServiceDelegationPublic"
  service-delegation-name = "Microsoft.Web/serverFarms"
  actions = "Microsoft.Network/virtualNetworks/subnets/action"
}

module "asn-private" {
  source = "./modules/subnet-private"

  subnet-name          = "snet-${module.configuration.project-name}-private-${module.configuration.environment}"
  resource-group-name  = "__rgterraform__"
  virtual-network-name = module.vnet.name
  address-prefixes     = "10.0.2.0/24"
  delegation-name      = "AppServiceDelegation"
  service-delegation-name = "Microsoft.Web/serverFarms"
  actions = "Microsoft.Network/virtualNetworks/subnets/action"
}

# module "publicip" {
#   source = "./modules/public-ip"

#   pip-name                = "pip-${module.configuration.project-name}-${module.configuration.environment}"
#   resource-group-name     = "__rgterraform__"
#   resource-group-location = module.configuration.location
#   allocation-method       = "Static"
#   sku-name                = "Standard"
# }

locals {
  backend_address_pool_name      = "${module.vnet.name}-beap"
  frontend_port_name             = "${module.vnet.name}-feport"
  frontend_ip_configuration_name = "${module.vnet.name}-feip"
  http_setting_name              = "${module.vnet.name}-be-htst"
  listener_name                  = "${module.vnet.name}-httplstn"
  request_routing_rule_name      = "${module.vnet.name}-rqrt"
}

# module "appgateway" {
#   source = "./modules/app-gateway"

#   gw-name                 = "agw-${module.configuration.project-name}-${module.configuration.environment}"
#   resource-group-name     = "__rgterraform__"
#   resource-group-location = module.configuration.location
#   sku-name                = "WAF_v2"
#   sku-tier                = "WAF_v2"
#   sku-capacity            = "1"
#   gw-ip-config-name       = "ipconfig-${module.configuration.project-name}-${module.configuration.environment}"
#   subnet-frontend-id      = module.asn-public.id
#   public-ip-address-id    = module.publicip.id
#   frontend-port-name      = local.frontend_port_name
#   frontend-ip-config-name = local.frontend_ip_configuration_name
#   backend-address-pool    = local.backend_address_pool_name
#   backend-http-settings   = local.http_setting_name
#   http-listener-name      = local.listener_name
#   front-ip-config-name    = local.frontend_ip_configuration_name
#   request-routing-rule    = local.request_routing_rule_name
# }
# yeet

module "container-registry" {
  source = "./modules/container-registry"

  container-name          = "__acrname__"
  resource-group-name     = "__rgterraform__"
  resource-group-location = module.configuration.location
  container-sku-name      = "Standard"
}

module "service-plan" {
  source = "./modules/service-plan"

  service-plan-name       = "asp-${module.configuration.project-name}-${module.configuration.environment}"
  service-plan-os_type    = "Linux"
  service-plan-sku_name   = "B1"
  resource-group-name     = "__rgterraform__"
  resource-group-location = module.configuration.location
}

# module "nsg-public" {
#   source = "./modules/network-security-group"

#   nsg-name                = "nsg-public-${module.configuration.project-name}-${module.configuration.environment}"
#   resource-group-name     = "__rgterraform__"
#   resource-group-location = module.configuration.location

#   sr-name                    = "sr-public-${module.configuration.project-name}-${module.configuration.environment}"
#   priority                   = "1001"
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source-port-range          = "*"
#   destination-port-range     = "*"
#   source-address-prefix      = "*"
#   destination-address-prefix = "*"
# }

module "webapp" {
  source = "./modules/webapp"

  webapp-name             = "ase-${module.configuration.project-name}-app-${module.configuration.environment}"
  resource-group-name     = "__rgterraform__"
  resource-group-location = module.configuration.location
  service-plan-id         = module.service-plan.id
  acr-name                = module.container-registry.name
  image-tag               = "app"
  admin_username          = module.container-registry.admin_username
  admin_password          = module.container-registry.admin_password
}

# module "nsg-ass-public" {
#   source = "./modules/nsg-associate"

#   subnet-id = module.asn-public.id
#   network-security-group-id = module.nsg-public.id
# }

# module "asn-webapp" {
#   source = "./modules/asn-webapp"

#   app-service-id = module.webapp.id
#   subnet-id = module.asn-private.id
# }

# module "nsg-private" {
#   source = "./modules/network-security-group"

#   nsg-name                = "nsg-private-${module.configuration.project-name}-${module.configuration.environment}"
#   resource-group-name     = "__rgterraform__"
#   resource-group-location = module.configuration.location

#   sr-name                    = "sr-private-${module.configuration.project-name}-${module.configuration.environment}"
#   priority                   = "1001"
#   direction                  = "Inbound"
#   access                     = "Deny"
#   protocol                   = "Tcp"
#   source-port-range          = "*"
#   destination-port-range     = "*"
#   source-address-prefix      = "Internet"
#   destination-address-prefix = "*"
# }

module "webapi" {
  source = "./modules/webapi"

  webapp-name             = "ase-${module.configuration.project-name}-api-${module.configuration.environment}"
  resource-group-name     = "__rgterraform__"
  resource-group-location = module.configuration.location
  service-plan-id         = module.service-plan.id
  acr-name                = module.container-registry.name
  image-tag               = "api"
  subnet-id               = module.asn-private.id
  allow-vnet              = module.asn-private.id
  admin_username          = module.container-registry.admin_username
  admin_password          = module.container-registry.admin_password
}

# module "nsg-ass-private" {
#   source = "./modules/nsg-associate"

#   subnet-id = module.asn-private.id
#   network-security-group-id = module.nsg-private.id
# }

# module "asn-webapi" {
#   source = "./modules/asn-webapi"

#   app-service-id = module.webapi.id
#   subnet-id = module.asn-private.id
# }

# module "webhook-api" {
#   source = "./modules/webhook"

#   registry-name = module.container-registry.name
#   name = "webhook${module.configuration.project-name}api${module.configuration.environment}"
#   location = module.configuration.location
#   service-uri = module.webapi.webhook-uri
#   rg-name = "__rgterraform__"
# }

# module "webhook-app" {
#   source = "./modules/webhook"

#   registry-name = module.container-registry.name
#   name = "webhook${module.configuration.project-name}app${module.configuration.environment}"
#   location = module.configuration.location
#   service-uri = module.webapp.webhook-uri
#   rg-name = "__rgterraform__"
# }

# module "storage-account" {
#   source = "./modules/storage-account"

#   storage-name             = "stcvprod"
#   resource-group-name      = "__rgterraform__"
#   resource-group-location  = module.configuration.location
#   account-tier             = "Standard"
#   account-replication-type = "LRS"
# }

# module "psqlserver" {
#   source = "./modules/poprodresql-server"

#   psql-name               = "psql-cv-prod"
#   resource-group-name     = "__rgterraform__"
#   resource-group-location = module.configuration.location

#   administrator-login          = "psqladmin"
#   administrator-login-password = "Qq4WwtDNT2K5"

#   sku-name     = "GP_Gen5_2"
#   psql-version = "11"
#   storage-mb   = "5120"

#   backup-retention-days        = "7"
#   geo-redundant-backup-enabled = false
#   auto-grow-enabled            = false
#   public-network-access        = false
#   ssl-enforcement-enabled      = true
#   tls-version-enforced         = "TLS1_2"
# }

# module "dbpsql" {
#   source = "./modules/poprodresql-db"

#   db-name             = "dbpsql-cv-prod"
#   resource-group-name = "__rgterraform__"
#   server-name         = module.psqlserver.name
#   charset             = "UTF8"
#   collation           = "en-GB"
# }
