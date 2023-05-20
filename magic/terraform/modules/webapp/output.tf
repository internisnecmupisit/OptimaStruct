output "id" {
  value = azurerm_linux_web_app.webapp.id
}

output "webhook-uri" {
  value = "https://${azurerm_linux_web_app.webapp.site_credential[0].name}:${azurerm_linux_web_app.webapp.site_credential[0].password}@${azurerm_linux_web_app.webapp.name}.scm.azurewebsites.net/api/registry/webhook"
}