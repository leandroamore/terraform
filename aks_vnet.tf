resource "azurerm_resource_group" "vnet" {
    name              = "${var.prefix}_${var.environment}_vnet"
    location          = var.location
    tags              = var.tags
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.prefix}${var.environment}vnet"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = azurerm_resource_group.vnet.location
  address_space       = [var.address_space]
  tags                = var.tags
} 

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes      = [var.AKSSubnet]
}
resource "azurerm_subnet" "waf_subnet" {
  name                 = "waf_subnet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes      = [var.WAFSubnet]
}
