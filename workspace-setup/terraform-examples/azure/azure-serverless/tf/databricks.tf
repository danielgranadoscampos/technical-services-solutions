# Serverless workspace, created through the ARM API (Microsoft.Databricks/workspaces, api-version 2026-01-01).
# computeMode = "Serverless" is the whole difference from a classic workspace: Databricks hosts the compute
# plane and the workspace storage, so there is no managed resource group, VNet injection, NSG rules or DBFS
# storage account. ARM rejects managedResourceGroupId, requiredNsgRules, accessConnector, defaultCatalog and
# defaultStorageFirewall on serverless workspaces. computeMode cannot be changed after creation.
resource "azapi_resource" "workspace" {
  type      = "Microsoft.Databricks/workspaces@2026-01-01"
  name      = local.workspace_name
  parent_id = local.resource_group_id
  location  = local.resource_group_location
  tags      = var.tags

  body = {
    sku = {
      name = "premium"
    }
    properties = {
      computeMode = "Serverless"
    }
  }

  response_export_values = ["properties.workspaceId", "properties.workspaceUrl"]
}

locals {
  workspace_id  = azapi_resource.workspace.output.properties.workspaceId
  workspace_url = "https://${azapi_resource.workspace.output.properties.workspaceUrl}"
}

# assign admin access to the workspace (skipped when admin_user is empty)

data "databricks_user" "workspace_access" {
  count     = var.admin_user != "" ? 1 : 0
  provider  = databricks.accounts
  user_name = var.admin_user
}

resource "databricks_mws_permission_assignment" "workspace_access" {
  count        = var.admin_user != "" ? 1 : 0
  provider     = databricks.accounts
  workspace_id = local.workspace_id
  principal_id = data.databricks_user.workspace_access[0].id
  permissions  = ["ADMIN"]
  depends_on = [
    databricks_metastore_assignment.this
  ]
}
