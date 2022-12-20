resource "azurerm_role_assignment" "base" {
  scope                = var.scope
  role_definition_name = "Network Contributor"
  principal_id         = var.principal_id
}