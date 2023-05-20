variable "resource-group-name" {
  type = string
}

variable "resource-group-location" {
  type = string
}

variable "psql-name" {
  type = string
}

variable "administrator-login" {
  type = string
}

variable "administrator-login-password" {
  type = string
}

variable "sku-name" {
  type = string
}

variable "psql-version" {
  type = string
}

variable "storage-mb" {
  type = string
}

variable "backup-retention-days" {
  type = string
}

variable "geo-redundant-backup-enabled" {
  type = bool
}

variable "auto-grow-enabled" {
  type = bool
}

variable "public-network-access" {
  type = bool
}

variable "ssl-enforcement-enabled" {
  type = bool
}

variable "tls-version-enforced" {
  type = string
}