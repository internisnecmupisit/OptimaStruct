output "id" {
  value = azurerm_linux_web_app.webapi.id
}

output "webhook-uri" {
  value = "https://${azurerm_linux_web_app.webapi.site_credential[0].name}:${azurerm_linux_web_app.webapi.site_credential[0].password}@${azurerm_linux_web_app.webapi.name}.scm.azurewebsites.net/api/registry/webhook"
}