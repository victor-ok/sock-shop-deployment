data "azurerm_kubernetes_service_versions" "versions" {
  location = var.rg_location
}