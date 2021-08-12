resource "azurerm_resource_group" "k8s" {
    name                         = "${var.prefix}_${var.environment}_aks"
    location                     = var.location
    tags                         = var.tags
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length                  = 5
}

data "azuread_group" "k8s" {
  name = var.aad_group_name
}
resource "azurerm_log_analytics_workspace" "oms" {
    
    name                          = "${var.prefix}${var.environment}logs-${random_id.log_analytics_workspace_name_suffix.dec}"
    location                      = var.location
    resource_group_name           = azurerm_resource_group.k8s.name
    sku                           = var.log_analytics_workspace_sku
    tags                          = var.tags
}

resource "azurerm_log_analytics_solution" "oms" {
    solution_name                 = "ContainerInsights"
    location                      = azurerm_log_analytics_workspace.oms.location
    resource_group_name           = azurerm_resource_group.k8s.name
    workspace_resource_id         = azurerm_log_analytics_workspace.oms.id
    workspace_name                = azurerm_log_analytics_workspace.oms.name

    plan {
        publisher                 = "Microsoft"
        product                   = "OMSGallery/ContainerInsights"
    }
}
resource "azurerm_kubernetes_cluster" "k8s" {
    name                           = "${var.prefix}${var.environment}aks"
    kubernetes_version             = var.k8s_Version
    location                       = azurerm_resource_group.k8s.location
    resource_group_name            = azurerm_resource_group.k8s.name
    dns_prefix                     = "${var.prefix}${var.environment}aks"

  linux_profile {
    admin_username                 = var.admin_username
    ssh_key {
      key_data                     = file(var.ssh_public_key)
    }
  }
  identity {
    type                           = "SystemAssigned"
  }
  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      admin_group_object_ids = [
        data.azuread_group.k8s.id
      ]
    }
  }
  network_profile {
    network_plugin                 = "azure"
    load_balancer_sku              = "standard"
    service_cidr                   = var.service_cidr
    dns_service_ip                 = var.dns_service_ip
    docker_bridge_cidr             = "172.17.0.1/16"
  }
  default_node_pool {
        name                       = "agentpool"
        node_count                 = var.agent_count
        vm_size                    = "Standard_DS2_v2"
        vnet_subnet_id             = azurerm_subnet.aks_subnet.id
        type                       = "VirtualMachineScaleSets"
        enable_auto_scaling = true
        min_count           = var.min_count
        max_count           = var.max_count
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.oms.id
        }
    kube_dashboard {
      enabled                      = true
    }
    }

    tags                           = var.tags
     lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}
resource "azurerm_role_assignment" "aks_subnet" {
  scope                = azurerm_subnet.aks_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}
resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
