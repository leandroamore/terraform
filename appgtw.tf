resource "azurerm_resource_group" "AppGtw" {
    name                         = "${var.prefix}_${var.environment}_aks"
    location                     = var.location
    tags                         = var.tags
}

resource "azurerm_public_ip" "AppGtw" {
    name                         = "${var.prefix}${var.environment}appgtwIP"
    location                     = azurerm_resource_group.AppGtw.location
    resource_group_name          = azurerm_resource_group.AppGtw.name
    allocation_method            = "Static"
    sku                          = "Standard"

    tags = var.tags
}
resource "azurerm_application_gateway" "AppGtw" {
    name                = "${var.prefix}${var.environment}appgtw"
    resource_group_name = azurerm_resource_group.AppGtw.name
    location            = azurerm_resource_group.AppGtw.location

    sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
    }

    gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.waf_subnet.id
    }

    frontend_port {
    name = "httpPort"
    port = 80
    }

    frontend_port {
    name = "httpsPort"
    port = 443
    }

    frontend_ip_configuration {
    name                 = "Ingress-feIP"
    public_ip_address_id = azurerm_public_ip.AppGtw.id
    }

    backend_address_pool {
    name = "Ingress"
    }

    backend_http_settings {
    name                  = "http80"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    }

    http_listener {
    name                           = "ingress-listener"
    frontend_ip_configuration_name = "Ingress-feIP"
    frontend_port_name             = "httpPort"
    protocol                       = "Http"
    }

    request_routing_rule {
    name                       = "RoutingIngress"
    rule_type                  = "Basic"
    http_listener_name         = "ingress-listener"
    backend_address_pool_name  = "Ingress"
    backend_http_settings_name = "http80"
    }

    tags = var.tags

    
}