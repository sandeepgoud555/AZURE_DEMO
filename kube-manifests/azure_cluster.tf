terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "san_aks_rg" {
  name     = "san_aks_rg"
  location = "UK South"
}

resource "azurerm_kubernetes_cluster" "san_aks" {
  name                = "san_aks"
  location            = azurerm_resource_group.san_aks_rg.location
  resource_group_name = azurerm_resource_group.san_aks_rg.name
  dns_prefix          = "san_aks"

  default_node_pool {
    name       = "sanpool"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = "990b7bfc-6f00-48b1-941e-58476eeaf976"
    client_secret = "iJO8Q~yxUiuOuM1uRUq3ZYQWb1Mh9ifh3fRhicAw"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "sannp" {
  name                  = "sannp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.san_aks.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1

  tags = {
    Environment = "test1"
  }
}