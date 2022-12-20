resource "azurerm_route_table" "table" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

#   route {
#     name           = "AKS"
#     address_prefix = var.address_prefix
#     next_hop_type  = "None"
#   }
}