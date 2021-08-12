resource "azurerm_resource_group" "acr" {
  name                         = "${var.prefix}_${var.environment}_acr"
  location                     = var.location
  tags                         = var.tags
}
resource "azurerm_container_registry" "acr" {
  name                     = "${var.prefix}${var.environment}${azurerm_resource_group.acr.location}acr"
  resource_group_name      = azurerm_resource_group.acr.name
  location                 = azurerm_resource_group.acr.location
  sku                      = "Basic"
  admin_enabled            = false
  tags                     = var.tags
}