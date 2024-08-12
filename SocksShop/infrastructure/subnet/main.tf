resource "azurerm_subnet" "subnets" {
  count = var.subnetNum
  name = count.index == 0 ? "${var.prefix}Subnet1" : format("%sSubnet%d", var.prefix, count.index + 1)
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = [ cidrsubnet(var.address_space, 3, count.index) ]
}
