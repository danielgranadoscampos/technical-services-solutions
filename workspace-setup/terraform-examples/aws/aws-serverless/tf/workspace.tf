# Serverless workspace. compute_mode = "SERVERLESS" is the whole difference from a
# classic workspace: Databricks hosts the compute plane and the workspace storage,
# so no credentials_id, storage_configuration_id or network_id is passed (the API
# rejects credentials_id and storage_configuration_id for serverless workspaces).
# compute_mode cannot be changed later; changing it forces a new workspace.
resource "databricks_mws_workspaces" "this" {
  provider       = databricks.mws
  account_id     = var.databricks_account_id
  workspace_name = var.workspace_name
  aws_region     = var.region
  compute_mode   = "SERVERLESS"
}

# Workspace admin for var.workspace_admin_email (skipped when empty). Errors at apply time
# if the email is not a Databricks account user.
data "databricks_user" "workspace_admin" {
  count     = var.workspace_admin_email != "" ? 1 : 0
  provider  = databricks.mws
  user_name = var.workspace_admin_email
}

resource "databricks_mws_permission_assignment" "workspace_admin" {
  count        = var.workspace_admin_email != "" ? 1 : 0
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = data.databricks_user.workspace_admin[0].id
  permissions  = ["ADMIN"]

  # Assign only once the workspace has its metastore.
  depends_on = [databricks_metastore_assignment.this]
}
