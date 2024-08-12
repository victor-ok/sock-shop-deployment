output "subnet1_id" {
  value = azurerm_subnet.subnets[0].id
}

output "subnet2_id" {
  value = azurerm_subnet.subnets[1].id
}