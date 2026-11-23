# Workspace resource group: created when create_resource_group is true, otherwise looked up.
# A serverless workspace has no managed resource group, VNet, NSG or DBFS storage account,
# so this group holds only the workspace resource itself.
resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

data "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  # When reusing a resource group, its region drives the workspace and every regional resource.
  resource_group_name     = var.create_resource_group ? azurerm_resource_group.this[0].name : data.azurerm_resource_group.this[0].name
  resource_group_id       = var.create_resource_group ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.this[0].id
  resource_group_location = var.create_resource_group ? azurerm_resource_group.this[0].location : data.azurerm_resource_group.this[0].location

  # Databricks workspace name: explicit value, or derived from resource_prefix (Azure CAF "dbw-" abbreviation).
  workspace_name = var.workspace_name != "" ? var.workspace_name : "dbw-${var.resource_prefix}"
}
