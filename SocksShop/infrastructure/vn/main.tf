resource "azurerm_virtual_network" "vnet" {
  name = "${var.prefix}Vnet"
  location = var.rg_location
  resource_group_name = var.rg_name
  address_space = [ var.address_space ]
}
