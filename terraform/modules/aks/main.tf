resource "azurerm_kubernetes_cluster" "main" {
  name                         = "aks-${var.name}"
  dns_prefix                   = "aks-${var.name}"
  location                     = var.location
  resource_group_name          = var.rg_name
  kubernetes_version           = var.aks_version
  azure_policy_enabled         = true
  sku_tier                     = var.aks_sku_tier
  image_cleaner_interval_hours = 72
  tags                         = var.tags

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  # oms_agent {
  #   log_analytics_workspace_id = var.law_id
  # }

  default_node_pool {
    name                        = "defaultpool"
    vm_size                     = var.aks_node_vm_size
    os_disk_size_gb             = 30
    type                        = "VirtualMachineScaleSets"
    node_count                  = 1
    temporary_name_for_rotation = "temppool"

    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3

    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin = "azure"
  }

  # role_based_access_control_enabled = true

  # azure_active_directory_role_based_access_control {
  #   azure_rbac_enabled = true
  #   tenant_id          = var.tenant_id
  # }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}
