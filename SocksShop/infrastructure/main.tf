module "rg" {
  source = "./resourceGroup"
  prefix = var.prefix
  location = var.location
}

module "vn" {
  source = "./vn"
  prefix = var.prefix
  rg_location = module.rg.rg_location
  rg_name = module.rg.rg_name
  address_space = var.address_space
  depends_on = [ module.rg ]
}

module "subnet" {
  source = "./subnet"
  prefix = var.prefix
  subnetNum = var.subnetNum
  vnet_name = module.vn.vnet_name
  rg_name = module.rg.rg_name
  address_space = var.address_space
  depends_on = [ module.vn ]
}


module "aks" {
  source = "./aks"
  prefix = var.prefix
  rg_location = module.rg.rg_location
  rg_name = module.rg.rg_name
  rg_id = module.rg.rg_id
  role_definition_name = var.role_definition_name
  service_cidr = var.service_cidr
  dns_service_ip = var.dns_service_ip
  subnet1_id  = module.subnet.subnet1_id
  vm_size = var.vm_size
  node_count = var.node_count
  min_count = var.min_count
  max_count = var.max_count
  enable_auto_scaling = var.enable_auto_scaling
  private_cluster_enabled = var.private_cluster_enabled
  automatic_channel_upgrade = var.automatic_channel_upgrade
  sku_tier = var.sku_tier
  oidc_issuer_enabled = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled
}