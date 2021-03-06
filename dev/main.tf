terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "k8sResourceGroup"
  location = "eastus2"
}
resource "azurerm_kubernetes_cluster" "cluster" {
  name = "k8scluster"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = "k8scluster"
  
  default_node_pool {
    name = "default"
    node_count = "1"
    vm_size = "standard_dc2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}