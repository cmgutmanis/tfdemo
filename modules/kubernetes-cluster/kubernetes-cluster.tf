################# HACK



######################

resource "azurerm_kubernetes_cluster" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "cgaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = var.vnet_subnet_id

  }

  identity {
    type = "UserAssigned"
    identity_ids = [var.identity_id]
    }

  tags = {
    Environment = "Production"
  }
}