  resource "azurerm_user_assigned_identity" "aks_identity" {
  name = "${var.prefix}aksidentity"
  location = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_role_assignment" "aks_identity_assignment" {
  scope = var.rg_id
  role_definition_name = var.role_definition_name
  principal_id = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name = "${var.prefix}aks"
  location = var.rg_location
  resource_group_name = var.rg_name
  dns_prefix = "${var.prefix}aksdns"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.versions.latest_version
  private_cluster_enabled = var.private_cluster_enabled
  automatic_channel_upgrade = var.automatic_channel_upgrade
  node_resource_group = "${var.prefix}aksnode"
  sku_tier = var.sku_tier
  oidc_issuer_enabled = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  network_profile {
    network_plugin = "azure"
    service_cidr = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  default_node_pool {
    name = "default"
    vm_size = var.vm_size
    vnet_subnet_id = var.subnet1_id
    orchestrator_version = data.azurerm_kubernetes_service_versions.versions.latest_version
    type = "VirtualMachineScaleSets" 
    enable_auto_scaling = var.enable_auto_scaling
    node_count = var.node_count
    min_count = var.min_count
    max_count = var.max_count
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
    create_before_destroy = true
  }

  depends_on = [azurerm_role_assignment.aks_identity_assignment]
}